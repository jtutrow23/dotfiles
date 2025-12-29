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

# Plugins (add/remove to taste)
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
