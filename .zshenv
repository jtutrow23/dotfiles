# Minimal zshenv — keep it tiny and fast
export ZDOTDIR="$HOME/.config/zsh"
# Homebrew on Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true
