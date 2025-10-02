# --- Minimal, sane Zsh config (repo-managed) ---

# Homebrew env (safe if brew exists)
if command -v brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true
fi

# Options: sane, predictable shell
setopt promptsubst autocd interactivecomments no_beep
setopt hist_ignore_dups hist_ignore_all_dups share_history

# History (compact & safe)
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"
HISTSIZE=5000
SAVEHIST=5000

# Completion
autoload -Uz compinit
compinit -i -C 2>/dev/null || true

# PATH niceties (only if dirs exist)
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)

# Prompt (Starship optional)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
