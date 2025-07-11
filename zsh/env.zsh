# ~/dotfiles/zsh/env.zsh

# Shell options
setopt AUTO_CD AUTO_PUSHD HIST_IGNORE_ALL_DUPS SHARE_HISTORY

# Paths (Homebrew always first)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Editor and other core env
export EDITOR="nvim"
export PAGER="less -R"
export FZF_DEFAULT_COMMAND='fd --type f'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555"
export FUNCNEST=1000
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Homebrew env (best practice for Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"