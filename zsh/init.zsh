# ~/dotfiles/zsh/init.zsh

# Load shell options + env vars
source "${0:A:h}/env.zsh"

# Ensure Znap is installed
[[ -r ~/dotfiles/Repos/znap/znap.zsh ]] || git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/dotfiles/Repos/znap
source ~/dotfiles/Repos/znap/znap.zsh

# Load plugins and prompt
source "${0:A:h}/plugins.zsh"
source "${0:A:h}/prompt.zsh"

# Customizations
source "${0:A:h}/aliases.sh"
source "${0:A:h}/functions.sh"
