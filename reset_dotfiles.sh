#!/usr/bin/env zsh
set -euo pipefail

# What we manage
MANAGED=(
  "$HOME/.zshrc"
  "$HOME/.zshenv"
  "$HOME/.config/zsh"
  "$HOME/.config/nvim"
  "$HOME/.config/starship.toml"
)

BACKUP_ROOT="$HOME"
TS=$(date +%Y%m%d_%H%M%S)
RESET_BACKUP="$BACKUP_ROOT/dotfiles_reset_$TS"
DRYRUN=0

usage() {
  cat <<USAGE
Usage:
  reset_dotfiles.sh              # backup & remove managed files/symlinks
  reset_dotfiles.sh --dry-run    # show what would happen
  reset_dotfiles.sh --list       # list existing backups
  reset_dotfiles.sh --restore    # restore from most recent backup
  reset_dotfiles.sh --restore PATH/TO/BACKUP  # restore from specific backup dir

Backups are named: ~/dotfiles_reset_YYYYMMDD_HHMMSS
USAGE
}

log() { printf "%s\n" "$*"; }
doit() { (( DRYRUN )) && log "[dry-run] $*" || eval "$*"; }

latest_backup() {
  ls -1dt "$BACKUP_ROOT"/dotfiles_reset_* 2>/dev/null | head -n 1
}

backup_and_remove() {
  local target="$1"
  if [[ -L "$target" || -f "$target" || -d "$target" ]]; then
    doit "mkdir -p '$RESET_BACKUP'"
    log "📦 Backing up $target -> $RESET_BACKUP/"
    doit "mv '$target' '$RESET_BACKUP/'"
  fi
}

restore_one() {
  local src_root="$1"
  local rel="$2"
  local src="$src_root/$rel"
  local dst="$HOME/$rel"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    # nothing to restore for this entry; skip quietly
    return 0
  fi

  # If something already exists at destination, back it up separately
  if [[ -L "$dst" || -f "$dst" || -d "$dst" ]]; then
    local collide_backup="$BACKUP_ROOT/dotfiles_restore_collision_$TS"
    doit "mkdir -p '$collide_backup/$(dirname "$rel")'"
    log "♻️  Moving existing $dst -> $collide_backup/"
    doit "mv '$dst' '$collide_backup/$(basename "$rel")'"
  fi

  # Ensure parent dir exists for nested paths
  doit "mkdir -p '$(dirname "$dst")'"

  log "↩️  Restoring $rel"
  doit "mv '$src' '$dst'"
}

list_backups() {
  local found=0
  for d in "$BACKUP_ROOT"/dotfiles_reset_*; do
    [[ -d "$d" ]] || continue
    found=1
    printf "%s\n" "$d"
  done
  (( found )) || log "(no backups found matching $BACKUP_ROOT/dotfiles_reset_*)"
}

# ---------------------------
# Parse args
# ---------------------------
if (( $# == 0 )); then
  MODE="reset"
else
  case "${1:-}" in
    --dry-run) DRYRUN=1; MODE="reset" ;;
    --list)    MODE="list" ;;
    --restore) MODE="restore"; RESTORE_ARG="${2:-}" ;;
    -h|--help) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
fi

# ---------------------------
# Execute
# ---------------------------
case "$MODE" in
  list)
    list_backups
    ;;

  reset)
    log "🧹 Resetting managed dotfiles (backup first)…"
    for t in "${MANAGED[@]}"; do
      backup_and_remove "$t"
    done
    if [[ -d "$RESET_BACKUP" ]]; then
      log "✅ Reset complete. Backup at: $RESET_BACKUP"
    else
      log "ℹ️  Nothing to back up; no managed files found."
    fi
    ;;

  restore)
    # Determine backup source
    if [[ -n "${RESTORE_ARG:-}" ]]; then
      SRC="$RESTORE_ARG"
    else
      SRC="$(latest_backup)"
    fi

    if [[ -z "${SRC:-}" || ! -d "$SRC" ]]; then
      log "❌ No valid backup directory found."
      log "Tip: run '--list' to see available backups, or pass one to --restore."
      exit 1
    fi

    log "🔁 Restoring from: $SRC"
    # Map list for restore: make paths relative to $HOME
    RELS=(
      ".zshrc"
      ".zshenv"
      ".config/zsh"
      ".config/nvim"
      ".config/starship.toml"
    )

    for rel in "${RELS[@]}"; do
      restore_one "$SRC" "$rel"
    done

    # If backup dir is now empty (everything restored), keep it anyway for audit.
    log "✅ Restore complete. If anything existed already, it was moved to a 'dotfiles_restore_collision_$TS' folder."
    ;;

  *)
    usage; exit 1 ;;
esac