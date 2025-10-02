#!/usr/bin/env zsh
set -euo pipefail

echo "🔄 Setting up dotfiles..."

BACKUP="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"

# Symlink helper
link_file() {
  local src="$1" dst="$2"
  if [[ -L "$dst" || -f "$dst" || -d "$dst" ]]; then
    echo "📦 Backing up $dst → $BACKUP/"
    mv "$dst" "$BACKUP"/
  fi
  echo "🔗 Linking $dst → $src"
  ln -s "$src" "$dst"
}

# Ensure ~/.config exists
mkdir -p "$HOME/.config"

# Core configs
link_file "$HOME/dotfiles/.config/zsh" "$HOME/.config/zsh"
link_file "$HOME/dotfiles/.config/nvim" "$HOME/.config/nvim"
link_file "$HOME/dotfiles/.config/starship.toml" "$HOME/.config/starship.toml"

# Entry points
link_file "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
link_file "$HOME/dotfiles/.zshenv" "$HOME/.zshenv"

echo "✅ Dotfiles setup complete."
echo "Run: exec zsh   to reload your shell."
