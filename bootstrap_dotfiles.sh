#!/bin/bash
# ─── 🚀 Dotfiles Bootstrap for Apple Silicon Macs ────────────────

set -e

# 🧰 Define paths safely
export DOTFILES="${DOTFILES:-$HOME/dotfiles}"
export ZSHDIR="${ZSHDIR:-$DOTFILES/zsh}"
export ZSHRC="${ZSHRC:-$HOME/.zshrc}"

# 🗂 Ensure expected folder structure
mkdir -p "$ZSHDIR/Repos"
mkdir -p "$ZSHDIR"

# 🔗 Symlink .zshrc to init.zsh in ZSHDIR
if [[ -e "$ZSHRC" && ! -L "$ZSHRC" ]]; then
    echo "⚠️  Backing up original .zshrc to .zshrc.backup"
    mv "$ZSHRC" "$ZSHRC.backup"
fi
ln -sf "$ZSHDIR/init.zsh" "$ZSHRC"

# 🧪 Install Homebrew if not already present
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 🧼 Patch Brewfile for compatibility (skip Onyx on unsupported macOS)
if [[ $(sw_vers -productVersion | awk -F. '{print $1}') -ge 15 ]]; then
    echo "🚫 Skipping Onyx: Not supported on macOS Sequoia or newer"
    sed -i '' '/onyx/d' "$DOTFILES/Brewfile" 2>/dev/null || true
fi

# ✅ Install apps from Brewfile
if [[ -f "$DOTFILES/Brewfile" ]]; then
    brew bundle --file="$DOTFILES/Brewfile" || echo "⚠️  One or more dependencies failed to install."
else
    echo "⛔️ Missing Brewfile at $DOTFILES/Brewfile"
fi

# 🧹 Ensure modular zsh files exist
for f in init.zsh env.zsh plugins.zsh prompt.zsh aliases.zsh functions.zsh; do
    touch "$ZSHDIR/$f"
done

# ⚡️ Ensure /zsh/Repos/ is in .gitignore
[[ -f "$DOTFILES/.gitignore" ]] || touch "$DOTFILES/.gitignore"
grep -qxF '/zsh/Repos/' "$DOTFILES/.gitignore" || echo '/zsh/Repos/' >> "$DOTFILES/.gitignore"

# 🧼 Source Zsh config if interactive
if [[ $- == *i* ]]; then
    source "$ZSHRC"
    echo "✅ Zsh loaded with dotfiles. Run 'znap pull' to update plugins."
else
    echo "✅ Dotfiles bootstrap complete. Open a new terminal to load Zsh config."
fi

