#!/bin/bash
# ─── 🚀 Dotfiles Bootstrap for Apple Silicon Macs ───────────────────────────

set -e

# 🧰 Define paths
DOTFILES="$HOME/dotfiles"  # Change if your dotfiles live elsewhere
ZSHRC="$HOME/.zshrc"

# 🗂 Ensure expected folder structure
mkdir -p "$HOME/Repos"
mkdir -p "$DOTFILES/zsh"

# 🔗 Symlink .zshrc to dotfiles version
if [[ -e "$ZSHRC" && ! -L "$ZSHRC" ]]; then
    echo "⚠️  Backing up original .zshrc to .zshrc.backup"
    mv "$ZSHRC" "$ZSHRC.backup"
fi
ln -sf "$DOTFILES/zsh/.zshrc" "$ZSHRC"

# 🧪 Confirm Homebrew exists
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ✅ Install core tools
brew bundle --file="$DOTFILES/Brewfile"

# 💡 Optional: Initialize mise
# mise activate zsh

# 🧼 Source Zsh config
source "$ZSHRC"
echo "✅ Zsh loaded with dotfiles. Run 'znap pull' to update plugins."

# ─────────────────────────────────────────────────────────────────────────────