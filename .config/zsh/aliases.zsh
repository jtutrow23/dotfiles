# ls/eza
if command -v eza >/dev/null 2>&1; then
  alias ls='eza'
  alias ll='eza -lh'
  alias la='eza -lha'
else
  alias ll='ls -lh'
  alias la='ls -lha'
fi

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

# safety/convenience
alias grep='grep --color=auto'
alias dfh='df -h'
alias duh='du -hd1'
alias please='sudo'

# git
alias gs='git status -sb'
alias ga='git add -A'
alias gc='git commit'
alias gca='git commit -a'
alias gp='git push'
alias gl='git pull --ff-only'
alias gco='git checkout'
alias gb='git branch -vv'
alias gsw='git switch'
alias gsu='git submodule update --init --recursive'

# brew
alias brewu='brew update && brew upgrade && brew cleanup -s && brew doctor'
