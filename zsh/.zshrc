eval "$(mise activate zsh)"

# Prompt (minimal)
eval "$(starship init zsh)"

# fzf (keybindings + completion)
# Homebrew installs fzf shell integration here.
source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"