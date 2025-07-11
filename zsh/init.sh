# ~/dotfiles/zsh/init.sh

# ─── Load Znap ───────────────────────────────────────────────────────────────
[[ -r ~/Repos/znap/znap.zsh ]] || \
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh

# ─── Znap Config ─────────────────────────────────────────────────────────────
zstyle ':znap:*' repos-dir ~/Repos
# zstyle ':znap:*' auto-compile no  # Disable background compile if needed

# ─── Prompt ──────────────────────────────────────────────────────────────────
znap prompt sindresorhus/pure
# To try Starship instead, comment above and uncomment:
# znap eval starship 'starship init zsh'
# export STARSHIP_CONFIG=~/dotfiles/zsh/starship.toml

# ─── Plugins ─────────────────────────────────────────────────────────────────
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source jeffreytse/zsh-vi-mode
znap source Aloxaf/fzf-tab
znap source marlonrichert/zsh-autocomplete
znap source hlissner/zsh-autopair

# ─── Optional Tool Activation ────────────────────────────────────────────────
znap eval mise 'mise activate zsh'
# znap function _pyenv pyenv "znap eval pyenv 'pyenv init - --no-rehash'"
# compctl -K _pyenv pyenv

# ─── Homebrew Path Setup ─────────────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ─── Environment Variables ───────────────────────────────────────────────────
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
export EDITOR="nvim"
export PAGER="less"
export FZF_DEFAULT_COMMAND='fd --type f'
