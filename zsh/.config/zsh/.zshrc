export ZDOTDIR="$HOME/.config/zsh"
source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/exports.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"
autoload -Uz compinit && compinit -i
command -v starship >/dev/null && eval "$(starship init zsh)"
