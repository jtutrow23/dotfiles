# ── Environment ──────────────────────────────────────────────

[[ -o interactive ]] || return

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export PATH="$HOME/.local/bin:$PATH"

export EDITOR="nano"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R"

# ── History ──────────────────────────────────────────────────

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# ── Shell ────────────────────────────────────────────────────

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

# ── Completion ───────────────────────────────────────────────

autoload -Uz compinit
compinit

zstyle ':completion:*' menu no
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|=*' \
  'l:|=* r:|=*'

# ── fzf ──────────────────────────────────────────────────────

export FZF_DEFAULT_OPTS="
  --height=70%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='❯ '
  --pointer='▶'
  --marker='✓'
"

export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null'
  --preview-window=right:60%:wrap
"

export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --icons=always --color=always {} 2>/dev/null'
  --preview-window=right:60%
"

source <(fzf --zsh)

# ── zoxide ───────────────────────────────────────────────────

eval "$(zoxide init zsh)"

# ── mise ─────────────────────────────────────────────────────

eval "$(mise activate zsh)"

# ── Aliases ──────────────────────────────────────────────────

alias ls='eza --icons=auto'
alias ll='eza -lah --icons=auto --group-directories-first'
alias la='eza -a --icons=auto --group-directories-first'
alias lt='eza --tree --level=2 --icons=auto'

alias cat='bat --paging=never'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

alias c='clear'
alias reload='exec zsh'

# ── Sheldon ──────────────────────────────────────────────────

eval "$(sheldon source)"

# ── fzf-tab ──────────────────────────────────────────────────

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':fzf-tab:complete:cd:*' \
  fzf-preview 'eza --tree --level=2 --icons=always --color=always "$realpath" 2>/dev/null'

zstyle ':fzf-tab:complete:*:*' \
  fzf-preview 'if [[ -d $realpath ]]; then
    eza --tree --level=2 --icons=always --color=always "$realpath" 2>/dev/null
  elif [[ -f $realpath ]]; then
    bat --color=always --style=numbers --line-range=:300 "$realpath" 2>/dev/null
  fi'

zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':completion:*:git-checkout:*' sort false

# ── Starship ─────────────────────────────────────────────────

eval "$(starship init zsh)"


