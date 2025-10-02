# Load Znap (clone if missing)
if [[ ! -d $HOME/.znap ]]; then
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/.znap
fi
source ~/.znap/znap.zsh

# Plugins (lean: no history plugin)
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-completions

# Starship prompt (optional)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Completion system
autoload -Uz compinit
compinit -i -C 2>/dev/null || true

# Modular loads
[[ -r "$ZDOTDIR/options.zsh"   ]] && source "$ZDOTDIR/options.zsh"
[[ -r "$ZDOTDIR/aliases.zsh"   ]] && source "$ZDOTDIR/aliases.zsh"
[[ -r "$ZDOTDIR/functions.zsh" ]] && source "$ZDOTDIR/functions.zsh"

znap source zsh-users/zsh-autosuggestions
# Subtle ghosted suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
# (Optional) Accept with Ctrl-f
bindkey "^F" autosuggest-accept

znap source Aloxaf/fzf-tab
# fzf-tab styles (compact, preview when available)
zstyle ":completion:*:descriptions" format "%F{8}%d%f"
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":fzf-tab:complete:*" fzf-preview "bat --style=numbers --color=always --line-range=:500 --plain --pager=never $realpath 2>/dev/null || eza -lah --group-directories-first --color=always $realpath 2>/dev/null || file --brief $realpath"
zstyle ":fzf-tab:*" switch-group "ctrl-h" "ctrl-l"

[[ -r "$ZDOTDIR/extras.zsh" ]] && source "$ZDOTDIR/extras.zsh"
