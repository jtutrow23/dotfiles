# --- ZDOTDIR guard (normally set in ~/.zshenv) ---
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

# --- Znap install/load ---
if [[ ! -d $HOME/.znap ]]; then
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.znap"
fi
source "$HOME/.znap/znap.zsh"

# --- Paths (repo-local tools) ---
[[ -d "$HOME/dotfiles/bin" ]] && path=("$HOME/dotfiles/bin" $path)

# --- Core shell options, aliases, functions ---
[[ -r "$ZDOTDIR/options.zsh"   ]] && source "$ZDOTDIR/options.zsh"
[[ -r "$ZDOTDIR/aliases.zsh"   ]] && source "$ZDOTDIR/aliases.zsh"
[[ -r "$ZDOTDIR/functions.zsh" ]] && source "$ZDOTDIR/functions.zsh"
[[ -r "$ZDOTDIR/extras.zsh"    ]] && source "$ZDOTDIR/extras[[ -r "$ZDOTDIR/exma[[ -r "$ZDOTDIR/extras.zsh"   gin[[ -r "$ZDOTDIR/extras.zsh"    ]] s/# Keep .zshenv minimal: point Z zexport ZDOTDIR="$HOME/.config/zsh"
