#!/usr/bin/env python3
"""Conservative allowlist cleanup. Python 3; macOS only. No sudo.

Default: preview only. --apply prints a fresh preview, then deletes eligible
regular files. Directories are retained. Never scans documents or Downloads.
"""
import argparse
import os
from pathlib import Path
import stat
import subprocess
import sys
import time

OFFICE = ('com.microsoft.Excel', 'com.microsoft.Word',
          'com.microsoft.Powerpoint', 'com.microsoft.onenote.mac')
# Never touch recovery, identity, sync, or document-like files even in caches.
PROTECTED = ('autorecovery', 'autorecover', 'unsaved', 'officefilecache',
             'credential', 'keychain', 'token', 'cookie', 'password',
             'identity', 'license', 'licensing', 'bookmark')
DOCUMENTS = {'.xlsx', '.xls', '.xlsm', '.xlsb', '.csv', '.doc', '.docx',
             '.ppt', '.pptx', '.pdf', '.one', '.odt', '.ods', '.rtf',
             '.numbers', '.pages', '.key'}
LOGS = {'.log', '.crash', '.ips', '.trace'}


def targets(home):
    lib = home / 'Library'
    for app in OFFICE:
        yield lib / 'Caches' / app, 'cache'
        yield lib / 'Containers' / app / 'Data/Library/Caches', 'cache'
        yield lib / 'Containers' / app / 'Data/Library/Logs', 'log'
    # Only dedicated caches; never the shared Office group container,
    # Application Support, Outlook mail, AutoRecovery, or general Office tmp.
    for name in ('Homebrew', 'pip', 'io.sentry', 'SentryCrash'):
        yield lib / 'Caches' / name, 'cache'
    yield home / '.npm/_cacache', 'cache'
    yield lib / 'Logs', 'log'
    # Only exact metadata filenames, without traversing user folders.
    yield home / '.DS_Store', 'junk'
    yield home / 'Desktop/.DS_Store', 'junk'


def fingerprint(s):
    return (s.st_dev, s.st_ino, s.st_size, s.st_mtime_ns, s.st_ctime_ns)


def safe_parent(path):
    """Walk from / with O_NOFOLLOW to avoid redirected ancestor paths.

    Return a parent directory descriptor, also used for unlinkat-style deletion.
    This avoids following a symlink swapped into an ancestor during cleanup.
    """
    flags = os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW
    fd = os.open('/', flags)
    try:
        for part in path.parent.parts[1:]:
            nxt = os.open(part, flags, dir_fd=fd)
            os.close(fd)
            fd = nxt
        return fd
    except BaseException:
        os.close(fd)
        raise


def inspect(path):
    fd = safe_parent(path)
    try:
        return os.stat(path.name, dir_fd=fd, follow_symlinks=False)
    finally:
        os.close(fd)


def scan(home, cache_days, log_days):
    cutoff = time.time()
    found, warnings = {}, []
    for root, category in targets(home):
        try:
            s = inspect(root)
        except FileNotFoundError:
            continue
        except OSError as exc:
            warnings.append(f'{root}: {exc.strerror}')
            continue
        if stat.S_ISLNK(s.st_mode):
            warnings.append(f'{root}: skipped symlink')
            continue
        print(f'SCAN {category}: {root}')
        paths = [root]
        if stat.S_ISDIR(s.st_mode):
            paths = []
            for base, dirs, files in os.walk(root, followlinks=False,
                    onerror=lambda e: warnings.append(str(e))):
                dirs[:] = [d for d in dirs if not any(
                    x in d.lower() for x in PROTECTED)]
                paths.extend(Path(base) / f for f in files)
        for path in paths:
            try:
                s = inspect(path)
                if not stat.S_ISREG(s.st_mode) or s.st_uid != os.getuid() or s.st_nlink != 1:
                    continue
                if any(x in str(path.relative_to(home)).lower() for x in PROTECTED):
                    continue
                if path.suffix.lower() in DOCUMENTS:
                    continue
                if category == 'log' and not (path.suffix.lower() in LOGS or
                        path.name.lower().endswith(('.log.gz', '.log.1', '.log.2'))):
                    continue
                days = log_days if category == 'log' else cache_days
                # Both mtime and ctime must be stale: newly copied files stay.
                if max(s.st_mtime, s.st_ctime) > cutoff - days * 86400:
                    continue
                found[path] = (fingerprint(s), s.st_blocks * 512)
            except OSError as exc:
                warnings.append(f'{path}: {exc.strerror}')
    return found, warnings


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument('--apply', action='store_true', help='Delete after printing fresh inventory')
    mode.add_argument('--dry-run', action='store_true', help='Preview only (default)')
    parser.add_argument('--cache-days', type=int, default=7, help='Minimum cache/junk age (default 7, minimum 1)')
    parser.add_argument('--log-days', type=int, default=14, help='Minimum log age (default 14, minimum 1)')
    args = parser.parse_args()
    if sys.platform != 'darwin' or os.getuid() == 0:
        parser.error('Run on macOS as your normal user, without sudo.')
    if min(args.cache_days, args.log_days) < 1:
        parser.error('Age thresholds must be at least one day.')
    home = Path.home().absolute()
    print('APPLY' if args.apply else 'DRY RUN — no files will be deleted')
    found, warnings = scan(home, args.cache_days, args.log_days)
    for path, (sig, allocated) in sorted(found.items()):
        print(f'WOULD REMOVE {sig[2]:>12,d} bytes  {str(path)!r}')
    total = sum(v[0][2] for v in found.values())
    allocated = sum(v[1] for v in found.values())
    print(f'\nEligible: {len(found):,} files; logical {total:,} bytes; '
          f'allocated estimate {allocated:,} bytes ({allocated / 1048576:.2f} MiB).')
    print('Actual reclaimed space can differ due to APFS clones/snapshots.')
    for warning in warnings:
        print('SKIPPED/INACCESSIBLE:', warning)
    if not args.apply:
        print('Nothing deleted. Review this inventory before explicitly running --apply.')
        return
    # Do not terminate applications automatically. Refuse if Office, browsers,
    # package managers, or updaters are active; recheck open files individually.
    processes = subprocess.run(['/bin/ps', '-axo', 'comm='],
                               capture_output=True, text=True, check=True).stdout
    blockers = ('microsoft excel', 'microsoft word', 'microsoft powerpoint',
                'microsoft onenote', 'microsoft outlook', 'microsoft autoupdate',
                'safari', 'google chrome', 'firefox', 'microsoft edge',
                '/brew', '/pip', '/npm')
    active = sorted({p for p in processes.splitlines()
                     if any(b in p.lower() for b in blockers)})
    if active:
        print('Apply refused. Quit these apps/processes and rerun:\n' + '\n'.join(active))
        return 2
    removed = skipped = failed = 0
    for path, (sig, _) in found.items():
        try:
            # lsof status 1 with no stderr means no visible open handles.
            opened = subprocess.run(['/usr/sbin/lsof', '-t', '--', str(path)],
                                    capture_output=True, text=True)
            if opened.returncode != 1 or opened.stderr:
                print(f'SKIP open file or uncertain open status: {str(path)!r}')
                skipped += 1
                continue
            fd = safe_parent(path)
            try:
                current = os.stat(path.name, dir_fd=fd, follow_symlinks=False)
                if fingerprint(current) != sig or not stat.S_ISREG(current.st_mode):
                    print(f'SKIP changed since preview: {str(path)!r}')
                    skipped += 1
                    continue
                os.unlink(path.name, dir_fd=fd)
                removed += 1
                print(f'REMOVED {str(path)!r}')
            finally:
                os.close(fd)
        except OSError as exc:
            failed += 1
            print(f'FAILED {str(path)!r}: {exc}')
    print(f'Deleted {removed}; skipped {skipped}; failed {failed}.')
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main())
