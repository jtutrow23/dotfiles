# Znap (zsh-snap) bootstrap + plugins
# Keeps ~/.zshrc clean by living as a "topic" in this dotfiles repo.

export ZNAP_DIR="${ZDOTDIR:-$HOME}/.znap"

# Clone on first run if missing
if [[ ! -r "$ZNAP_DIR/znap.zsh" ]]; then
  if command -v git >/dev/null 2>&1; then
    git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$ZNAP_DIR"
  else
    echo "znap: git is required to install zsh-snap" >&2
    return 1
  fi
fi

# Load Znap
source "$ZNAP_DIR/znap.zsh"

# --- plugins ---------------------------------------------------------------

# Suggestions as you type
znap source zsh-users/zsh-autosuggestions

# Extra completion definitions (pairs well with your completion.zsh)
znap source zsh-users/zsh-completions

# Fast syntax highlighting (very popular, low drama)
znap source zdharma-continuum/fast-syntax-highlighting

# Better tab completion UX (predictive, menu-style)
znap source marlonrichert/zsh-autocomplete

# fzf-powered completion menu (optional but awesome)
znap source Aloxaf/fzf-tab

# --- small, safe defaults --------------------------------------------------

# Autosuggestions: accept with → (right arrow)
bindkey '→' autosuggest-accept 2>/dev/null || true

# fzf-tab preview (safe; if fzf-tab isn’t loaded it does nothing)
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:complete:*:*' fzf-preview 'ls -la --color=auto $realpath 2>/dev/null'