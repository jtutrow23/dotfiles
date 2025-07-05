# ~/.dotfiles/zsh/aliases.sh

# --- Navigation ---
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"

# --- File Management ---
alias l="ls -lah"
alias la="ls -A"
alias ll="ls -lG"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# --- Git ---
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias gd="git diff"
alias gb="git branch"

# --- Homebrew ---
alias bubu="brew update && brew upgrade && brew cleanup"

# --- Misc ---
alias c="clear"
alias reload="source ~/.zshrc"
alias openconfig="nano ~/.zshrc"

# --- Quick Access ---
alias dotfiles="cd ~/dotfiles"
alias repos="cd ~/Repos"