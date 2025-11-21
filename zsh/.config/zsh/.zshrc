# Main Zsh config

# Load options
[[ -f "$ZDOTDIR/options.zsh" ]] && source "$ZDOTDIR/options.zsh"

# Load exports
[[ -f "$ZDOTDIR/exports.zsh" ]] && source "$ZDOTDIR/exports.zsh"

# Load aliases
[[ -f "$ZDOTDIR/aliases.zsh" ]] && source "$ZDOTDIR/aliases.zsh"

# Load functions
[[ -f "$ZDOTDIR/functions.zsh" ]] && source "$ZDOTDIR/functions.zsh"

# Prompt (Starship)
command -v starship >/dev/null && eval "$(starship init zsh)"
