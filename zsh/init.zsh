# ~/dotfiles/zsh/init.zsh

# Safely define path variables
export DOTFILES="${DOTFILES:-$HOME/dotfiles}"
export ZSHDIR="${ZSHDIR:-$DOTFILES/zsh}"

# Always source env first (sets up znap)
source "$ZSHDIR/env.zsh"

# Then the rest of your config
source "$ZSHDIR/plugins.zsh"
source "$ZSHDIR/prompt.zsh"
source "$ZSHDIR/aliases.zsh"
source "$ZSHDIR/functions.zsh"

