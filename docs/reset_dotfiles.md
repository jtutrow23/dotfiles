#!/usr/bin/env zsh
set -euo pipefail

echo "🧹 Resetting dotfiles symlinks..."

BACKUP="$HOME/dotfiles_reset_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"

# Helper to move if link or file exists
backup_and_remove() {
  local target="$1"
  if [[ -L "$target" || -f "$target" || -d "$target" ]]; then
    echo "📦 Backing up $target → $BACKUP/"
    mv "$target" "$BACKUP"/
  fi
}

# Remove repo symlinks
backup_and_remove "$HOME/.zshrc"
backup_and_remove "$HOME/.zshenv"
backup_and_remove "$HOME/.config/zsh"
backup_and_remove "$HOME/.config/nvim"
backup_and_remove "$HOME/.config/starship.toml"

echo "✅ Reset complete."
echo "All previous configs were moved into: $BACKUP"
