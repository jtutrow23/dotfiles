# Set fallback ZSHDIR if not already defined
export DOTFILES="${DOTFILES:-$HOME/dotfiles}"
export ZSHDIR="${ZSHDIR:-$DOTFILES/zsh}"

# Source modular files from the zsh config directory
source "$ZSHDIR/env.zsh"
source "$ZSHDIR/plugins.zsh"
source "$ZSHDIR/prompt.zsh"
source "$ZSHDIR/aliases.zsh"
source "$ZSHDIR/functions.zsh"
