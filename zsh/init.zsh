# ~/dotfiles/zsh/init.zsh

# ──────────────────────────────────────────────────────────────────────────────
# Modular Zsh bootstrap — loads everything else, ensures clean plugin setup
# ──────────────────────────────────────────────────────────────────────────────

# 1. Load shell options & environment variables
source "${0:A:h}/env.zsh"

# 2. Set plugin repo directory for Znap (keep plugins in dotfiles/Repos)
zstyle ':znap:*' repos-dir ~/dotfiles/Repos

# 3. Ensure Znap is installed to the right folder
if [[ ! -r ~/dotfiles/Repos/znap/znap.zsh ]]; then
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/dotfiles/Repos/znap
fi
source ~/dotfiles/Repos/znap/znap.zsh

# 4. Load plugins and prompt (modular, from other files)
source "${0:A:h}/plugins.zsh"
source "${0:A:h}/prompt.zsh"

# 5. Load your custom aliases and functions
source "${0:A:h}/aliases.zsh"
source "${0:A:h}/functions.zsh"

# (Optional) Add more custom loads below...