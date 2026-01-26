eval "$(mise activate zsh)"

# fzf (completion only; no default keybindings)
source "$(brew --prefix)/opt/fzf/shell/completion.zsh"

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

# starship prompt
eval "$(starship init zsh)"
