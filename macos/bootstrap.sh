#!/usr/bin/env bash
#
# macos/bootstrap.sh
#
# One-shot setup for a new Mac:
# - Install Homebrew (if missing)
# - Run Brewfile
# - Stow Zsh + Starship config
# - Set Homebrew Zsh as default shell
# - Run macOS defaults script (if present)

set -euo pipefail

###############################################################################
# Helpers
###############################################################################

log()  { printf "\033[1;32m[INFO]\033[0m  %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m  %s\n" "$*"; }
err()  { printf "\033[1;31m[FAIL]\033[0m  %s\n" "$*" >&2; }

# Resolve repo root (…/dotfiles)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES_DIR"

###############################################################################
# 1. Sanity checks
###############################################################################

if [[ "$(uname -s)" != "Darwin" ]]; then
  err "This bootstrap script is macOS-only."
  exit 1
fi

log "Using dotfiles directory: $DOTFILES_DIR"

###############################################################################
# 2. Homebrew
###############################################################################

if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew not found; installing…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  log "Homebrew already installed."
fi

# Make sure Brew’s env is active in this shell
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

###############################################################################
# 3. Brewfile
###############################################################################

BREWFILE="$DOTFILES_DIR/Brewfile"

if [[ -f "$BREWFILE" ]]; then
  log "Running brew bundle with $BREWFILE"
  # Allow MAS / App Store failures without killing the script
  set +e
  brew bundle --file="$BREWFILE"
  BREW_STATUS=$?
  set -e

  if [[ $BREW_STATUS -ne 0 ]]; then
    warn "brew bundle completed with errors (likely MAS / App Store). Review the output above."
  else
    log "brew bundle completed successfully."
  fi
else
  warn "No Brewfile found at $BREWFILE – skipping brew bundle."
fi

# Ensure stow is available (even if not installed via Brewfile yet)
if ! command -v stow >/dev/null 2>&1; then
  log "Installing stow (missing but required for symlinks)…"
  brew install stow
fi

###############################################################################
# 4. Backup existing config & Stow
###############################################################################

BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

backup_target() {
  local rel="$1"
  local target="$HOME/$rel"

  if [[ -e "$target" && ! -L "$target" ]]; then
    local dest="$BACKUP_DIR/$rel"
    mkdir -p "$(dirname "$dest")"
    log "Backing up $target -> $dest"
    mv "$target" "$dest"
  fi
}

log "Backing up existing shell/config files (if any)…"
backup_target ".zshenv"
backup_target ".zprofile"
backup_target ".config/zsh"
backup_target ".config/starship.toml"

log "Stowing Zsh + Starship configs…"
stow -R zsh starship

###############################################################################
# 5. Default shell -> Homebrew Zsh
###############################################################################

BREW_ZSH="/opt/homebrew/bin/zsh"

if [[ -x "$BREW_ZSH" ]]; then
  if ! grep -q "$BREW_ZSH" /etc/shells; then
    log "Adding $BREW_ZSH to /etc/shells (sudo)…"
    echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
  fi

  if [[ "$SHELL" != "$BREW_ZSH" ]]; then
    log "Changing default shell to $BREW_ZSH (sudo chsh)…"
    sudo chsh -s "$BREW_ZSH" "$USER"
  else
    log "Default shell already set to $BREW_ZSH."
  fi
else
  warn "Expected Homebrew Zsh at $BREW_ZSH not found; skipping chsh."
fi

###############################################################################
# 6. macOS defaults (optional)
###############################################################################

DEFAULTS_SCRIPT="$DOTFILES_DIR/macos/defaults.sh"
if [[ -x "$DEFAULTS_SCRIPT" ]]; then
  log "Running macOS defaults script…"
  set +e
  "$DEFAULTS_SCRIPT"
  DS_STATUS=$?
  set -e

  if [[ $DS_STATUS -ne 0 ]]; then
    warn "defaults.sh exited with status $DS_STATUS – check its output if something looks off."
  else
    log "macOS defaults applied."
  fi
else
  warn "macos/defaults.sh not found or not executable; skipping macOS tweaks."
fi

###############################################################################
# 7. Done
###############################################################################

log "Bootstrap complete."

if [[ -d "$BACKUP_DIR" && "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
  log "Previous config was backed up to: $BACKUP_DIR"
else
  rm -rf "$BACKUP_DIR" 2>/dev/null || true
fi

echo
log "Close this terminal and open a new session to ensure all shell changes are active."
