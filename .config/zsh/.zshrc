# --- ZDOTDIR guard ---
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

# repo-local bin early
[[ -d "$HOME/dotfiles/bin" ]] && path=("$HOME/dotfiles/bin" $path)

# Homebrew env (early, quiet)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Install & load Znap
if [[ -r "$HOME/.znap/znap.zsh" ]]; then
  source "$HOME/.znap/znap.zsh"
else
  if command -v git >/dev/null; then
    git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.znap" \
      && source "$HOME/.znap/znap.zsh"
  fi
fi

# Core modules (guarded)
for f in options.zsh aliases.zsh functions.zsh extras.zsh; do
  [[ -r "$ZDOTDIR/$f" ]] && source "$ZDOTDIR/$f"
done

# Plugins via Znap (syntax-highlighting must be last)
if typeset -f znap >/dev/null; then
  znap source zsh-users/zsh-autosuggestions
  znap source zsh-users/zsh-completions
  znap source zsh-users/zsh-history-substring-search
  znap source zsh-users/zsh-syntax-highlighting

  # Stable vi-mode
  bindkey -v
  KEYTIMEOUT=1
fi

# Starship prompt (optional)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
