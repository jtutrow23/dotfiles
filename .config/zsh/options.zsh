# shell behavior
setopt promptsubst
setopt interactivecomments
setopt autocd
setopt no_beep
setopt notify

# history
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"
HISTSIZE=5000
SAVEHIST=5000
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt share_history

# completion cache cleanup and init (redundant-safe)
autoload -Uz compinit
compinit -i -C 2>/dev/null || true

# PATH niceties
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)

# Homebrew environment on Apple Silicon (safe if installed)
if command -v brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true
fi
