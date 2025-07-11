# ~/dotfiles/zsh/env.zsh

# Define DOTFILES and ZSHDIR safely
export DOTFILES="${DOTFILES:-$HOME/dotfiles}"
export ZSHDIR="${ZSHDIR:-$DOTFILES/zsh}"

# Ensure znap is installed and sourced
ZNAP_REPO="$ZSHDIR/Repos/znap"
if [[ ! -e "$ZNAP_REPO/znap.zsh" ]]; then
  echo "📦 Cloning znap..."
  git clone --depth=1 https://github.com/marlonrichert/zsh-snap.git "$ZNAP_REPO"
fi
source "$ZNAP_REPO/znap.zsh"
