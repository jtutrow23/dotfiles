# Minimal zshrc — modular load
setopt prompt_subst
export PATH="$HOME/bin:$PATH"

# Optional: Starship prompt
if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
fi

# Optional: zoxide
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# Optional: fzf keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load modular pieces if present
for f in options.zsh aliases.zsh functions.zsh extras.zsh; do
  [ -f "$ZDOTDIR/$f" ] && source "$ZDOTDIR/$f"
done
