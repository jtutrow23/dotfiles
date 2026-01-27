# =========================
# zsh — minimal, explicit
# =========================

# mise (runtime manager)
eval "$(mise activate zsh)"

# ---- completions (Homebrew-aware) ----
typeset -U fpath
fpath=(
  /opt/homebrew/share/zsh-completions
  /opt/homebrew/share/zsh/site-functions
  $fpath
)
fpath=(${fpath:#"/usr/local/share/zsh/site-functions"})

autoload -Uz compinit
compinit -C

# ---- autosuggestions (subtle) ----
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#565f89'
if [ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ---- direnv ----
eval "$(direnv hook zsh)"

# ---- fzf theme (Tokyonight-ish) ----
export FZF_DEFAULT_OPTS="
  --height=40% --layout=reverse --border
  --color=bg+:#1a1b26,bg:#1a1b26,spinner:#bb9af7,hl:#7aa2f7
  --color=fg:#c0caf5,header:#565f89,info:#9ece6a,pointer:#f7768e
  --color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7aa2f7
"

# fzf completion only (no default keybindings)
if [ -r /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# ---- fzf explicit keybindings ----
fzf_cmd_files() {
  fd --type f --hidden --follow --exclude .git 2>/dev/null
}

fzf_cmd_dirs() {
  fd --type d --hidden --follow --exclude .git 2>/dev/null
}

fzf_insert_file() {
  local sel
  sel="$(fzf_cmd_files | fzf --prompt='Files> ')" || return
  LBUFFER+="${(q)sel}"
  zle reset-prompt
}
zle -N fzf_insert_file
bindkey '^T' fzf_insert_file

fzf_cd_dir() {
  local dir
  dir="$(fzf_cmd_dirs | fzf --prompt='Dirs> ')" || return
  cd -- "$dir" || return
  zle reset-prompt
}
zle -N fzf_cd_dir
bindkey '^[c' fzf_cd_dir

fzf_history_search() {
  local sel
  sel="$(fc -rl 1 | sed 's/^[ ]*[0-9]*[ ]*//' | fzf --prompt='History> ')" || return
  LBUFFER+="$sel"
  zle reset-prompt
}
zle -N fzf_history_search
bindkey '^R' fzf_history_search

# ---- starship ----
eval "$(starship init zsh)"