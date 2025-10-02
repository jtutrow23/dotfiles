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

# repo-local executables
[[ -d "$HOME/dotfiles/bin" ]] && path=("$HOME/dotfiles/bin" $path)

# zoxide (better cd)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias zc="zoxide query -l | fzf | xargs -I{} z {}"
fi

# fzf defaults
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git --type f'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
else
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
