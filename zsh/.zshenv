# All Zsh config lives under ~/.config/zsh
export ZDOTDIR="$HOME/.config/zsh"

# Base PATH: prepend Homebrew and keep system dirs
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Inject Homebrew env if installed
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
