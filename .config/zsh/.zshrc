# --- ZDOTDIR guard ---
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

# repo-local bin early
[[ -d "$HOME/dotfiles/bin" ]] && path=("$HOME/dotfiles/bin" $path)

# Install & load Znap
if [[ ! -d "$HOME/.znap" ]]; then
  command -v git >/dev/null && \
    git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.znap" || true
fi
if [[ -r "$HOME/.znap/znap.zsh" ]]; then
  source "$HOME/.znap/znap.zsh"
else
  print "⚠️  Znap not available at $HOME/.znap/znap.zsh"
fi

# Core modules (guarded)
[[ -r "$ZDOTDIR/options.zsh"   ]] && source "$ZDOTDIR/options.zsh"
[[ -r "$ZDOTDIR/aliases.zsh"   ]] && source "$ZDOTDIR/aliases.zsh"
[[ -r "$ZDOTDIR/functions.zsh" ]] && source "$ZDOTDIR/functions.zsh"
[[ -r "$ZDOTDIR/extras.zsh"    ]] && source "$ZDOTDIR/extras.zsh"

# --- Plugins via Znap ---
if typeset -f znap >/dev/null; then
  # Autosuggestions (dim ghost text from history)
  znap source zsh-users/zsh-autosuggestions

  # Syntax highlighting (color input as you type)
  znap source zsh-users/zsh-syntax-highlighting

  # Extra completions
  znap source zsh-users/zsh-completions

  # History substring search (arrow keys cycle matching history)
  znap source zsh-users/zsh-history-substring-search

  # Stable built-in vi-mode
  bindkey -v
  KEYTIMEOUT=1
fi

# Starship prompt (optional)
if [[ -o interactive ]] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi