#!/bin/bash
# ─── 🚀 Dotfiles Bootstrap for Apple Silicon Macs ────────────────

set -e

# 🧰 Define paths
DOTFILES="$HOME/dotfiles"
ZSHDIR="$DOTFILES/zsh"
ZSHRC="$HOME/.zshrc"

# 🗂 Ensure expected folder structure
mkdir -p "$ZSHDIR/Repos"
mkdir -p "$ZSHDIR"

# 🔗 Symlink .zshrc to dotfiles version
if [[ -e "$ZSHRC" && ! -L "$ZSHRC" ]]; then
    echo "⚠️  Backing up original .zshrc to .zshrc.backup"
    mv "$ZSHRC" "$ZSHRC.backup"
fi
ln -sf "$ZSHDIR/.zshrc" "$ZSHRC"

# 🧪 Confirm Homebrew exists
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ✅ Install core tools
brew bundle --file="$DOTFILES/Brewfile"

# 🧹 Ensure all modular .zsh files exist (empty if not already)
for f in init.zsh env.zsh plugins.zsh prompt.zsh aliases.zsh functions.zsh; do
    [ -f "$ZSHDIR/$f" ] || touch "$ZSHDIR/$f"
done

# ⚡️ Add /zsh/Repos/ to .gitignore (for plugin repos)
grep -qxF '/zsh/Repos/' "$DOTFILES/.gitignore" || echo '/zsh/Repos/' >> "$DOTFILES/.gitignore"

# 🧼 Source Zsh config (for interactive installs only)
if [[ $- == *i* ]]; then
    source "$ZSHRC"
    echo "✅ Zsh loaded with dotfiles. Run 'znap pull' to update plugins."
else
    echo "✅ Dotfiles bootstrap complete. Open a new terminal to load Zsh config."
fi
