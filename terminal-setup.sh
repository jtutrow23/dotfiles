cat > ~/setup-terminal.sh <<'SCRIPT'
#!/usr/bin/env bash

set -Eeuo pipefail

echo "Setting up terminal environment..."

# ─────────────────────────────────────────────────────────────
# Homebrew
# ─────────────────────────────────────────────────────────────

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is not installed."
    echo "Install it from https://brew.sh and rerun this script."
    exit 1
fi

eval "$(brew shellenv)"

# ─────────────────────────────────────────────────────────────
# Packages
# ─────────────────────────────────────────────────────────────

brew update

brew install \
    starship \
    sheldon \
    fzf \
    eza \
    zoxide \
    bat \
    ripgrep \
    fd \
    dust \
    bottom \
    jq \
    zsh-completions

# Optional but useful developer tools
brew install \
    git \
    gh \
    tree \
    wget \
    curl

# Optional Nerd Font for eza and Starship icons
brew install --cask font-meslo-lg-nerd-font

# ─────────────────────────────────────────────────────────────
# Directories
# ─────────────────────────────────────────────────────────────

mkdir -p \
    "$HOME/.config/sheldon" \
    "$HOME/.config/starship" \
    "$HOME/.cache/zsh"

# ─────────────────────────────────────────────────────────────
# Sheldon plugins
#
# Order matters:
#   1. fzf-tab
#   2. autosuggestions
#   3. syntax highlighting last
# ─────────────────────────────────────────────────────────────

cat > "$HOME/.config/sheldon/plugins.toml" <<'EOF'
shell = "zsh"

[plugins.fzf-tab]
github = "Aloxaf/fzf-tab"

[plugins.zsh-autosuggestions]
github = "zsh-users/zsh-autosuggestions"
use = ["zsh-autosuggestions.zsh"]

[plugins.zsh-syntax-highlighting]
github = "zsh-users/zsh-syntax-highlighting"
use = ["zsh-syntax-highlighting.zsh"]
EOF

# ─────────────────────────────────────────────────────────────
# Back up existing zsh configuration
# ─────────────────────────────────────────────────────────────

if [[ -f "$HOME/.zshrc" ]]; then
    backup="$HOME/.zshrc.backup.$(date +%Y%m%d-%H%M%S)"
    cp "$HOME/.zshrc" "$backup"
    echo "Existing .zshrc backed up to: $backup"
fi

# ─────────────────────────────────────────────────────────────
# Zsh configuration
# ─────────────────────────────────────────────────────────────

cat > "$HOME/.zshrc" <<'EOF'
# Skip interactive configuration for non-interactive shells
[[ -o interactive ]] || return

# ─────────────────────────────────────────────────────────────
# Homebrew
# ─────────────────────────────────────────────────────────────

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# XDG directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# User executables
export PATH="$HOME/.local/bin:$PATH"

# Default tools
export EDITOR="nano"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R"

# ─────────────────────────────────────────────────────────────
# History
# ─────────────────────────────────────────────────────────────

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_D