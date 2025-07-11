# ~/dotfiles/zsh/prompt.zsh

# Load Pure prompt using znap
znap source sindresorhus/pure

# Only run promptinit if not already active
autoload -Uz promptinit && promptinit

# Use 'pure' if it's available and not already set
if typeset -f prompt_pure &>/dev/null; then
  prompt pure
fi
