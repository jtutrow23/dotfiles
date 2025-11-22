#!/usr/bin/env bash
set -euo pipefail

# Simple helpers for nicer output
info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$*"; }
error() { printf '\033[1;31m[FAIL]\033[0m  %s\n' "$*"; exit 1; }

info "Dotfiles bootstrap starting…"

###############################################################################
# 1. Ensure Homebrew is installed
###############################################################################
if ! command -v brew >/dev/null 2>&1; then
  info "Homebrew not found. Installing…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error "Homebrew install failed"

  # Add brew to PATH for future shells
  if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
    info "Adding Homebrew to ~/.zprofile"
    {
      echo
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    } >> "$HOME/.zprofile"
  fi

  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  info "Homebrew already installed: $(brew --version | head -1)"
fi

###############################################################################
# 2. Clone dotfiles if missing
###############################################################################
if [[ ! -d "$HOME/.dotfiles/.git" ]]; then
  info "Cloning dotfiles repo into ~/.dotfiles…"
  git clone git@github.com:jtutrow23/dotfiles.git "$HOME/.dotfiles" || error "git clone failed"
else
  info "Dotfiles repo already present at ~/.dotfiles"
fi

cd "$HOME/.dotfiles"

###############################################################################
# 3. Ensure Stow is available
###############################################################################
if ! command -v stow >/dev/null 2>&1; then
  info "Installing stow via Homebrew…"
  brew install stow || error "Failed to install stow"
fi

###############################################################################
# 4. Prepare clean Zsh environment
###############################################################################
info "Preparing Zsh environment (cleaning conflicting files)…"

rm -f "$HOME/.zshrc" \
      "$HOME/.zprofile" \
      "$HOME/.zshenv" 2>/dev/null || true

# If ~/.config/zsh is a real dir or wrong symlink, remove it
if [[ -e "$HOME/.config/zsh" && ! -L "$HOME/.config/zsh" ]]; then
  warn "~/.config/zsh exists and is not a symlink. Backing up to ~/.config/zsh.backup"
  mv "$HOME/.config/zsh" "$HOME/.config/zsh.backup"
fi

mkdir -p "$HOME/.config"

###############################################################################
# 5. Apply dotfile symlinks
###############################################################################
info "Stowing modules: zsh, starship, ssh, brew, macos…"

stow -R zsh starship ssh brew macos || error "stow failed"

###############################################################################
# 6. Ensure Znap plugin manager is installed
###############################################################################
if [[ ! -r "$HOME/.znap/znap.zsh" ]]; then
  info "Installing zsh-snap (Znap) plugin manager…"
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.znap" || error "Failed to clone zsh-snap"
else
  info "Znap already installed at ~/.znap"
fi

###############################################################################
# 7. Minimal Brew bundle (core tools)
###############################################################################
CORE_BREWFILE="$HOME/.dotfiles/brew/01-core-min.Brewfile"

if [[ -f "$CORE_BREWFILE" ]]; then
  info "Installing core Homebrew tools from $CORE_BREWFILE…"
  brew bundle --file "$CORE_BREWFILE" || warn "brew bundle (core) reported errors; continue manually if needed."
else
  warn "No core Brewfile found at brew/01-core-min.Brewfile – skipping bundle."
fi

info "Bootstrap complete. Starting a fresh login shell…"
exec zsh -l
