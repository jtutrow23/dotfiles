# Load Znap (clone if missing)
if [[ ! -d $HOME/.znap ]]; then
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/.znap
fi
source ~/.znap/znap.zsh

# Plugins (lean: no history plugin)
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-completions

# Starship prompt (optional)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Completion system
autoload -Uz compinit
compinit -i -C 2>/dev/null || true

# Modular loads
[[ -r "$ZDOTDIR/options.zsh"   ]] && source "$ZDOTDIR/options.zsh"
[[ -r "$ZDOTDIR/aliases.zsh"   ]] && source "$ZDOTDIR/aliases.zsh"
[[ -r "$ZDOTDIR/functions.zsh" ]] && source "$ZDOTDIR/functions.zsh"
