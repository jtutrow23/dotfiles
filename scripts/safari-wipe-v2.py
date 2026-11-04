#!/usr/bin/env python3
"""
Fast, defensive Safari local-data wipe for macOS.

Dry-run by default. Nothing is deleted unless --apply is supplied.

Scopes:
  cache    Browser/WebKit caches only.
  history  History/recent tabs/download list/icons/metadata plus caches.
  full     Everything above plus local cookies and WebsiteData.

Key safety/performance behavior:
  - One lsof snapshot for the current user; never one lsof call per candidate.
  - If any member of a SQLite family is open, that entire family is skipped.
  - Open unrelated files are skipped; they do not abort the whole cleanup.
  - Every file is revalidated immediately before unlinking.
  - Optional Safari/Passwords process termination is limited to current-user PIDs.

Preserves bookmarks, passwords, Keychain data, extensions, passkeys and
credential-like paths. Does not claim to erase remote/iCloud-synced history.
"""

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
import fcntl
import os
from pathlib import Path
import signal
import stat
import subprocess
import sys
import tempfile
import time
from typing import Iterable


PROTECTED_WORDS = (
    "password", "keychain", "credential", "webauthn", "mediakeys",
    "bookmark", "passkey", "extension",
)

KILL_MARKERS = (
    "/Safari.app/Contents/MacOS/Safari",
    "SafariBookmarksSyncAgent",
    "SafariLinkExtension",
    "com.apple.Safari.History",
    "SafariNotificationAgent",
    "SafariLaunchAgent",
    "Safari.SafeBrowsing.Service",
    "CredentialProviderExtensionHelper",
    "SafariPlatformSupport.framework",
    "/Passwords.app/",
)

SQLITE_SIDE_SUFFIXES = ("-wal", "-shm", "-journal", "-lock")


@dataclass(frozen=True)
class Candidate:
    path: Path
    category: str
    signature: tuple[int, int, int, int, int]
    logical_bytes: int
    allocated_bytes: int


def human_bytes(value: int) -> str:
    size = float(value)
    for unit in ("B", "KiB", "MiB", "GiB", "TiB"):
        if size < 1024 or unit == "TiB":
            return f"{size:.0f} {unit}" if unit == "B" else f"{size:.2f} {unit}"
        size /= 1024
    return f"{value} B"


def parent_fd(path: Path) -> int:
    flags = os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW
    fd = os.open("/", flags)
    try:
        for part in path.parent.parts[1:]:
            nxt = os.open(part, flags, dir_fd=fd)
            os.close(fd)
            fd = nxt
        return fd
    except BaseException:
        os.close(fd)
        raise


def inspect(path: Path) -> os.stat_result:
    fd = parent_fd(path)
    try:
        return os.stat(path.name, dir_fd=fd, follow_symlinks=False)
    finally:
        os.close(fd)


def signature(s: os.stat_result) -> tuple[int, int, int, int, int]:
    return s.st_dev, s.st_ino, s.st_size, s.st_mtime_ns, s.st_ctime_ns


def is_protected(path: Path, home: Path) -> bool:
    try:
        rel = str(path.relative_to(home)).lower()
    except ValueError:
        return True
    return any(word in rel for word in PROTECTED_WORDS)


def iter_profiles(safari_root: Path) -> Iterable[Path]:
    yield safari_root
    profiles = safari_root / "Profiles"
    try:
        if not stat.S_ISDIR(inspect(profiles).st_mode):
            return
        for child in profiles.iterdir():
            try:
                if stat.S_ISDIR(inspect(child).st_mode):
                    yield child
            except OSError:
                continue
    except (FileNotFoundError, PermissionError, NotADirectoryError):
        return


def targets(home: Path, scope: str) -> Iterable[tuple[Path, str]]:
    lib = home / "Library"
    sandbox = lib / "Containers/com.apple.Safari/Data/Library"
    safari_roots = (lib / "Safari", sandbox / "Safari")

    if scope in {"history", "full"}:
        history_names = (
            "History.db", "History.db-wal", "History.db-shm",
            "History.db-journal", "History.db-lock",
            "Downloads.plist", "RecentlyClosedTabs.plist",
            "LocalStorage", "Databases", "Favicon Cache",
            "Touch Icons Cache", "Metadata Cache",
        )
        for safari_root in safari_roots:
            for base in iter_profiles(safari_root):
                for name in history_names:
                    yield base / name, "history"

    for cache_root in (
        lib / "Caches/com.apple.Safari",
        sandbox / "Caches/com.apple.Safari",
    ):
        for name in (
            "WebKitCache", "fsCachedData", "Cache.db", "Cache.db-wal",
            "Cache.db-shm", "TabSnapshots", "OnboardingExtensionIconCache",
        ):
            yield cache_root / name, "cache"

    for name in ("NetworkCache", "CacheStorage"):
        yield sandbox / "Caches/WebKit" / name, "cache"

    if scope == "full":
        yield sandbox / "Cookies/Cookies.binarycookies", "cookies"
        yield sandbox / "WebKit/WebsiteData", "website-data"
        yield lib / "WebKit/com.apple.Safari/WebsiteData", "website-data"


def walk_regular_files(root: Path, home: Path, errors: list[str]) -> Iterable[Path]:
    try:
        s = inspect(root)
    except FileNotFoundError:
        return
    except OSError as exc:
        errors.append(f"{root}: {exc}")
        return

    if stat.S_ISLNK(s.st_mode):
        errors.append(f"Symlink skipped: {root}")
        return
    if stat.S_ISREG(s.st_mode):
        yield root
        return
    if not stat.S_ISDIR(s.st_mode):
        return

    for base, dirs, files in os.walk(
        root,
        followlinks=False,
        onerror=lambda exc: errors.append(str(exc)),
    ):
        dirs[:] = [
            d for d in dirs
            if not any(word in d.lower() for word in PROTECTED_WORDS)
        ]
        for name in files:
            path = Path(base) / name
            if not is_protected(path, home):
                yield path


def inventory(home: Path, scope: str) -> tuple[dict[Path, Candidate], list[str]]:
    found: dict[Path, Candidate] = {}
    errors: list[str] = []

    try:
        roots = list(targets(home, scope))
    except OSError as exc:
        return {}, [f"Cannot enumerate Safari roots: {exc}"]

    for root, category in roots:
        for path in walk_regular_files(root, home, errors):
            try:
                s = inspect(path)
                if (
                    stat.S_ISREG(s.st_mode)
                    and s.st_uid == os.getuid()
                    and s.st_nlink == 1
                    and not is_protected(path, home)
                ):
                    found[path] = Candidate(
                        path=path,
                        category=category,
                        signature=signature(s),
                        logical_bytes=s.st_size,
                        allocated_bytes=s.st_blocks * 512,
                    )
            except FileNotFoundError:
                continue
            except OSError as exc:
                errors.append(f"{path}: {exc}")

    return found, errors


def user_processes() -> list[tuple[int, str]]:
    result = subprocess.run(
        ["/bin/ps", "-axo", "pid=,uid=,command="],
        capture_output=True,
        text=True,
        check=True,
    )
    uid = os.getuid()
    matches: list[tuple[int, str]] = []

    for line in result.stdout.splitlines():
        parts = line.strip().split(None, 2)
        if len(parts) != 3:
            continue
        try:
            pid = int(parts[0])
            process_uid = int(parts[1])
        except ValueError:
            continue
        command = parts[2]
        if (
            pid != os.getpid()
            and process_uid == uid
            and any(marker in command for marker in KILL_MARKERS)
        ):
            matches.append((pid, command))
    return matches


def terminate_safari_stack(force: bool, wait_seconds: float) -> None:
    matches = user_processes()
    if not matches:
        print("Safari stack: no matching user-owned processes found.")
        return

    print(f"Safari stack: sending TERM to {len(matches)} user-owned process(es)...", flush=True)
    for pid, _ in matches:
        try:
            os.kill(pid, signal.SIGTERM)
        except (ProcessLookupError, PermissionError):
            pass

    deadline = time.monotonic() + wait_seconds
    while time.monotonic() < deadline:
        if not user_processes():
            break
        time.sleep(0.15)

    remaining = user_processes()
    if remaining and force:
        print(f"Safari stack: SIGKILL for {len(remaining)} remaining process(es)...", flush=True)
        for pid, _ in remaining:
            try:
                os.kill(pid, signal.SIGKILL)
            except (ProcessLookupError, PermissionError):
                pass
        time.sleep(0.35)

    remaining = user_processes()
    if remaining:
        print(
            f"Safari stack: {len(remaining)} process(es) remain or respawned; "
            "open files will be skipped safely.",
            flush=True,
        )
    else:
        print("Safari stack: clear.", flush=True)


def open_file_snapshot(timeout: float = 20.0) -> set[Path]:
    """Take ONE lsof snapshot of current-user open filesystem paths."""
    username = os.environ.get("USER")
    if not username:
        import pwd
        username = pwd.getpwuid(os.getuid()).pw_name

    print("Open-file preflight: taking one lsof snapshot...", flush=True)
    started = time.monotonic()
    try:
        result = subprocess.run(
            ["/usr/sbin/lsof", "-Fn", "-u", username],
            capture_output=True,
            text=True,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired as exc:
        raise RuntimeError(
            f"lsof snapshot exceeded {timeout:.0f}s; nothing deleted"
        ) from exc

    if result.returncode not in (0, 1):
        detail = result.stderr.strip() or f"exit status {result.returncode}"
        raise RuntimeError(f"lsof snapshot failed: {detail}")

    paths: set[Path] = set()
    for line in result.stdout.splitlines():
        if not line.startswith("n/"):
            continue
        raw = line[1:]
        if raw.endswith(" (deleted)"):
            raw = raw[:-10]
        if raw.startswith("/"):
            paths.add(Path(raw))

    elapsed = time.monotonic() - started
    print(
        f"Open-file preflight: captured {len(paths):,} open path(s) in {elapsed:.1f}s.",
        flush=True,
    )
    return paths


def sqlite_family(path: Path) -> Path | None:
    name = path.name
    for suffix in SQLITE_SIDE_SUFFIXES:
        if name.endswith(suffix):
            name = name[:-len(suffix)]
            break
    if name.lower().endswith((".db", ".sqlite", ".sqlite3")):
        return path.with_name(name)
    return None


def classify_open_candidates(
    candidates: dict[Path, Candidate],
    open_paths: set[Path],
) -> tuple[set[Path], set[Path], set[Path]]:
    candidate_paths = set(candidates)
    candidate_families = {
        family
        for path in candidate_paths
        if (family := sqlite_family(path)) is not None
    }
    open_families = {
        family
        for path in open_paths
        if (family := sqlite_family(path)) is not None
        and family in candidate_families
    }

    skip_paths: set[Path] = set()
    open_non_sqlite: set[Path] = set()
    for path in candidate_paths:
        family = sqlite_family(path)
        if family is not None and family in open_families:
            skip_paths.add(path)
        elif path in open_paths:
            skip_paths.add(path)
            open_non_sqlite.add(path)

    return skip_paths, open_non_sqlite, open_families


def confirm_apply(scope: str, count: int) -> bool:
    if not sys.stdin.isatty():
        return False
    print()
    print(
        f"About to permanently delete eligible local Safari data "
        f"(scope={scope}, candidates={count:,})."
    )
    return input("Type DELETE to continue: ").strip() == "DELETE"


def print_progress(current: int, total: int) -> None:
    if total <= 0:
        return
    if current == 1 or current == total or current % 250 == 0:
        pct = current * 100.0 / total
        print(f"Deleting: {current:,}/{total:,} ({pct:5.1f}%)", flush=True)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--scope",
        choices=("cache", "history", "full"),
        default="full",
        help="Cleanup scope (default: full; still dry-run unless --apply).",
    )
    parser.add_argument("--apply", action="store_true", help="Actually delete eligible files.")
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Skip interactive DELETE confirmation (requires --apply).",
    )
    parser.add_argument(
        "--quiet",
        action="store_true",
        help="Show summary only instead of every candidate path.",
    )
    parser.add_argument(
        "--kill-safari",
        action="store_true",
        help=(
            "Before apply preflight, TERM known Safari/Passwords processes "
            "owned by the current user."
        ),
    )
    parser.add_argument(
        "--force-kill",
        action="store_true",
        help="With --kill-safari, SIGKILL matching user-owned survivors.",
    )
    parser.add_argument(
        "--kill-wait",
        type=float,
        default=2.0,
        metavar="SECONDS",
        help="TERM grace period (default: 2.0).",
    )
    args = parser.parse_args()

    if args.yes and not args.apply:
        parser.error("--yes only makes sense with --apply")
    if args.force_kill and not args.kill_safari:
        parser.error("--force-kill requires --kill-safari")
    if args.kill_wait < 0:
        parser.error("--kill-wait must be >= 0")
    if sys.platform != "darwin" or os.getuid() == 0:
        parser.error("Run on macOS as your normal user; do not use sudo.")

    home = Path.home().absolute()
    lock_path = Path(tempfile.gettempdir()) / f"safari-wipe-{os.getuid()}.lock"

    with lock_path.open("w") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            print("Another safari-wipe process is already running.", file=sys.stderr)
            return 2

        print("APPLY requested" if args.apply else "DRY RUN — nothing will be deleted")
        print(f"Scope: {args.scope}")
        print("Scanning eligible Safari data...", flush=True)

        found, errors = inventory(home, args.scope)

        if not args.quiet:
            for candidate in sorted(found.values(), key=lambda c: str(c.path)):
                print(
                    f"WOULD DELETE [{candidate.category:12}] "
                    f"{human_bytes(candidate.logical_bytes):>10}  {candidate.path}"
                )

        logical = sum(c.logical_bytes for c in found.values())
        allocated = sum(c.allocated_bytes for c in found.values())
        by_category = Counter(c.category for c in found.values())

        print()
        print(
            f"Eligible: {len(found):,} files; "
            f"logical {human_bytes(logical)}; "
            f"allocated estimate {human_bytes(allocated)}."
        )
        if by_category:
            print(
                "By category: "
                + ", ".join(f"{k}={v}" for k, v in sorted(by_category.items()))
            )

        for error in errors:
            print("INCOMPLETE:", error)

        if not args.apply:
            print("Nothing deleted. Review the inventory, then use --apply.")
            return 0
        if errors:
            print("Apply refused because the inventory was incomplete. Nothing deleted.")
            return 2
        if not args.yes and not confirm_apply(args.scope, len(found)):
            print("Cancelled. Nothing deleted.")
            return 0

        if args.kill_safari:
            terminate_safari_stack(args.force_kill, args.kill_wait)

        try:
            open_paths = open_file_snapshot()
        except RuntimeError as exc:
            print(f"Apply refused: {exc}")
            return 2

        skip_paths, open_non_sqlite, open_families = classify_open_candidates(
            found, open_paths
        )

        if open_families:
            print(
                f"SQLite safety: skipping {len(open_families):,} open "
                "database family/families."
            )
            for family in sorted(open_families, key=str):
                print(f"  SKIP FAMILY {family}*")

        if open_non_sqlite:
            print(
                f"Open-file safety: skipping {len(open_non_sqlite):,} "
                "directly-open non-SQLite candidate(s)."
            )
            for path in sorted(open_non_sqlite, key=str)[:20]:
                print(f"  SKIP OPEN   {path}")
            if len(open_non_sqlite) > 20:
                print(f"  ... and {len(open_non_sqlite) - 20:,} more")

        work = [c for c in found.values() if c.path not in skip_paths]
        print(
            f"Delete plan: {len(work):,} file(s); "
            f"{len(skip_paths):,} skipped because open.",
            flush=True,
        )

        removed = reclaimed = changed = missing = failed = 0

        for index, candidate in enumerate(work, start=1):
            print_progress(index, len(work))
            try:
                fd = parent_fd(candidate.path)
                try:
                    current = os.stat(
                        candidate.path.name,
                        dir_fd=fd,
                        follow_symlinks=False,
                    )
                    if (
                        not stat.S_ISREG(current.st_mode)
                        or current.st_uid != os.getuid()
                        or current.st_nlink != 1
                        or signature(current) != candidate.signature
                    ):
                        changed += 1
                        continue
                    os.unlink(candidate.path.name, dir_fd=fd)
                    removed += 1
                    reclaimed += candidate.allocated_bytes
                finally:
                    os.close(fd)
            except FileNotFoundError:
                missing += 1
            except OSError as exc:
                failed += 1
                print(f"FAILED {candidate.path}: {exc}", flush=True)

        print()
        print("Cleanup complete.")
        print(f"  Deleted:              {removed:,}")
        print(f"  Skipped open:         {len(skip_paths):,}")
        print(f"  SQLite families open: {len(open_families):,}")
        print(f"  Changed since scan:   {changed:,}")
        print(f"  Already missing:      {missing:,}")
        print(f"  Failed:               {failed:,}")
        print(f"  Allocated estimate:   {human_bytes(reclaimed)}")
        print("  Empty directories were retained.")
        print("  Remote/iCloud Safari data was not touched.")

        return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
