# Modular Zsh bootstrap

# Env first
source "${0:A:h}/env.zsh"

# Znap setup (with repos-dir set if not in ~/.zshenv already)
zstyle ':znap:*' repos-dir ~/dotfiles/Repos
[[ -r ~/dotfiles/Repos/znap/znap.zsh ]] || git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/dotfiles/Repos/znap
source ~/dotfiles/Repos/znap/znap.zsh

# Load plugins first, then prompt
source "${0:A:h}/plugins.zsh"
source "${0:A:h}/prompt.zsh"

# Custom
source "${0:A:h}/aliases.zsh"
source "${0:A:h}/functions.zsh"
