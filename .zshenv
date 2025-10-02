# Sourced on all invocations of the shell, this file should contain environment
# variables that should be available everywhere.

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Set up Homebrew path for both Apple Silicon and Intel Macs.
if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
if [[ -x /usr/local/bin/brew ]]; then eval "$(/usr/local/bin/brew shellenv)"; fi

# Keep syntax highlighters quiet about our custom fzf widgets.
typeset -gA ZSH_HIGHLIGHT_WIDGETS
ZSH_HIGHLIGHT_WIDGETS[menu-search]=.accept-line
ZSH_HIGHLIGHT_WIDGETS[recent-paths]=.self-insert
