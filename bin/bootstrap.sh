#!/bin/zsh
set -euo pipefail

echo "🔄 Bootstrapping macOS dotfiles + packages..."

# Ensure we're inside the repo
cd "$HOME/dotfiles" || { echo "❌ dotfiles repo not found"; exit 1; }

# Step 1: Symlink dotfiles
if [[ -x ./setup_dotfiles.sh ]]; then
  echo "⚙️  Running setup_dotfiles.sh..."
  zsh ./setup_dotfiles.sh
else
  echo "⚠️  setup_dotfiles.sh not found or not executable"
fi

# Step 2: Install Brewfile
if command -v brew >/dev/null; then
  echo "🍺 Running brew bundle..."
  brew bundle --no-lock
else
  echo "❌ Homebrew not installed — install it first!"
fi

# Step 3: Apply macOS defaults
if [[ -x ./macos_bootstrap.sh ]]; then
  echo "🖥️  Applying macOS defaults..."
  zsh ./macos_bootstrap.sh
else
  echo "⚠️  macos_bootstrap.sh not found or not executable"
fi

# Step 4: Warm Znap + precompile
if command -v warm >/dev/null; then
  echo "🔥 Warming plugins..."
  warm
else
  echo "⚠️  warm not found in PATH"
fi

echo "✅ Bootstrap complete. Restart your terminal to ensure all settings apply."