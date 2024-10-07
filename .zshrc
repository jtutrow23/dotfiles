# Environment Variables
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Plugin Management with Zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    echo "Installing ZDHARMA-CONTINUUM Initiative Plugin Manager..."
    mkdir -p "$HOME/.local/share/zinit" && chmod g-rwX "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        echo "Installation successful." || \
        echo "The clone has failed."
fi

source "${HOME}/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Zinit Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light git

# Uncomment below lines for optional features
# ENABLE_CORRECTION="true"
# HIST_STAMPS="mm/dd/yyyy"
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# zstyle ':omz:update' mode auto

# Preferred Editor
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# Aliases
alias zshconfig="nano ~/.zshrc"
alias zinitconfig="nano ~/.local/share/zinit/zinit.zsh"
alias reloadzsh="source ~/.zshrc"

# Uncomment to initialize Starship prompt
# eval "$(starship init zsh)"