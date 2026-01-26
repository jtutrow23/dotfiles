# mise (runtime manager)
eval "$(mise activate zsh)"

# ---- completions (minimal, Homebrew-aware) ----
typeset -U fpath  # de-dup entries

# Homebrew completions (Apple Silicon)
fpath=(
  /opt/homebrew/share/zsh-completions
  /opt/homebrew/share/zsh/site-functions
  $fpath
)

# Remove Intel-era completions path
fpath=(${fpath:#"/usr/local/share/zsh/site-functions"})

autoload -Uz compinit
compinit -C

# zsh autosuggestions (inline suggestions)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
if [ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# direnv (does nothing unless an .envrc exists)
eval "$(direnv hook zsh)"

# fzf (completion only; no default keybindings)
if [ -r /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# fzf (explicit keybindings; no defaults)
fzf_cmd_files() {
  command fd --type f --hidden --follow --exclude .git 2>/dev/null
}

fzf_cmd_dirs() {
  command fd --type d --hidden --follow --exclude .git 2>/dev/null
}

fzf_insert_file() {
  local sel
  sel="$(fzf_cmd_files | fzf --prompt='Files> ' --height=40% --layout=reverse --border)" || return
  LBUFFER+="${(q)sel}"
  zle reset-prompt
}
zle -N fzf_insert_file
bindkey '^T' fzf_insert_file

fzf_cd_dir() {
  local dir
  dir="$(fzf_cmd_dirs | fzf --prompt='Dirs> ' --height=40% --layout=reverse --border)" || return
  cd -- "$dir" || return
  zle reset-prompt
}
zle -N fzf_cd_dir
bindkey '^[c' fzf_cd_dir

fzf_history_search() {
  local sel
  sel="$(fc -rl 1 | sed 's/^[ ]*[0-9]*[ ]*//' | fzf --prompt='History> ' --height=40% --layout=reverse --border)" || return
  LBUFFER+="$sel"
  zle reset-prompt
}
zle -N fzf_history_search
bindkey '^R' fzf_history_search

# starship prompt (interactive shells only)
if [[ -o interactive ]]; then
  eval "$(starship init zsh)"
fi