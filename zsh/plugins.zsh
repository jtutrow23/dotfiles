# ~/dotfiles/zsh/plugins.zsh

# Load in correct order
znap source jeffreytse/zsh-vi-mode

# Patch recursion
zvm_config() {
  ZVM_WIDGETS_IGNORE+=(zle-line-init zle-keymap-select)
}

# Core plugins
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source marlonrichert/zsh-autocomplete
znap source Aloxaf/fzf-tab
znap source hlissner/zsh-autopair
