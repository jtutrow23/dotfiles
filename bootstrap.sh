#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Xcode Command Line Tools if needed"
xcode-select -p >/dev/null 2>&1 || xcode-select --install || true

echo "==> Installing Homebrew if needed"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "==> Updating Homebrew"
brew update

echo "==> Installing main Brewfile"
brew bundle --file="$HOME/dotfiles/Brewfile"

echo "==> Installing personal Brewfile if present"
if [[ -f "$HOME/dotfiles/Brewfile.personal" ]]; then
  brew bundle --file="$HOME/dotfiles/Brewfile.personal"
fi

echo "==> Ensuring pipx path"
pipx ensurepath || true

echo "==> Installing useful pipx apps"
pipx install yt-dlp || true

echo "==> Cleaning old downloads"
brew cleanup --prune=all

echo "==> Done"
