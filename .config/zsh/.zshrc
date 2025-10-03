# --- ZDOTDIR guard (normally set in ~/.zshenv) ---
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

# --- Znap install/load ---
if [[ ! -d $HOME/.znap ]]; then
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.znap"
fi
source "$HOME/.znap/znap.zsh"

# --- repo-local executables on PATH ---
[[ -d "$HOME/dotfiles/bin" ]] && path=("$HOME/dotfiles/bin" $path)

# --- core modules (guarded) ---
[[ -r "$ZDOTDIR/options.zsh"   ]] && source "$ZDOTDIR/options.zsh"
[[ -r "$ZDOTDIR/aliases.zsh"   ]] && source "$ZDOTDIR/aliases.zsh"
[[ -r "$ZDOTDIR/functions.zsh" ]] && source "$ZDOTDIR/functions.zsh"
[[ -r "$ZDOTDIR/extras.zsh"    ]] && source "$ZDOTDIR/extras.zsh"

# --- Znap plugins (Homebrew plugin formulae removed) ---
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source zsh-users/zsh-history-substring-search
znap source jeffreytse/zsh-vi-mode

# --- Starship prompt ---
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
