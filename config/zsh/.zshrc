# Set Oh My Zsh directory
export ZSH="$HOME/.oh-my-zsh"

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Plugins
plugins=(git brew zsh-autosuggestions zsh-syntax-highlighting)

# Starship Prompt
eval "$(starship init zsh)"

# Aliases
alias cls="clear"
alias ll="ls -la"
alias gs="git status"
alias brewup="brew update && brew upgrade --greedy && brew cleanup"

# Path Updates
export PATH="$HOME/scripts:$HOME/tools:$PATH"

# 1Password CLI
alias op="~/tools/1password/op"

# Reload and Automation
alias reload="source ~/.zshrc"
alias update="~/dotfiles/scripts/maintenance/brew_update.sh"

# Enable Zsh options
setopt correct
setopt autocd