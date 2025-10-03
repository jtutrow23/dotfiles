# Marker to prove this file was sourced:
: ${ZDOTDIR:="$HOME/.config/zsh"}
export ZDOTDIR

# Ensure repo-local bin appears early
[[ -d "$HOME/dotfiles/bin" ]] && path=("$HOME/dotfiles/bin" $path)

# Install & load Znap
if [[ ! -d "$HOME/.znap" ]]; then
  command -v git >/dev/null && git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.znap" || true
fi
if [[ -r "$HOME/.znap/znap.zsh" ]]; then
  source "$HOME/.znap/znap.zsh"
else
  echo "⚠️  Znap missing: $HOME/.znap/znap.zsh not found"
fi

# Core modules (guarded)
[[ -r "$ZDOTDIR/options.zsh"   ]] && source "$ZDOTDIR/options.zsh"
[[ -r "$ZDOTDIR/aliases.zsh"   ]] && source "$ZDOTDIR/aliases.zsh"
[[ -r "$ZDOTDIR/functions.zsh" ]] && source "$ZDOTDIR/functions.zsh"
[[ -r "$ZDOTDIR/extras.zsh"    ]] && source "$ZDOTDIR/extras.zsh"

# Plugins via Znap (safe set)
if typeset -f znap >/dev/null; then
  znap source zsh-users/zsh-autosuggestions
  znap source zsh-users/zsh-completions
  znap source zsh-users/zsh-history-substring-search
  # jeffreytse/zsh-vi-mode disabled for now (was crashing). Use built-in vi-mode:
  bindkey -v
  KEYTIMEOUT=1
fi

# Starship prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
