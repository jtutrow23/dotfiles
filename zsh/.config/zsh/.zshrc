: "${ZDOTDIR:="$HOME/.config/zsh"}"

# ─── Znap (plugin manager) ──────────────────────────────────────────────
if [[ ! -r "$HOME/.znap/znap.zsh" ]]; then
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.znap"
fi
source "$HOME/.znap/znap.zsh"

# ─── Plugins ────────────────────────────────────────────────────────────
znap source zsh-users/zsh-autosuggestions
znap source zdharma-continuum/fast-syntax-highlighting
znap source zsh-users/zsh-completions

# ─── Layered config ─────────────────────────────────────────────────────
[[ -f "$ZDOTDIR/options.zsh"   ]] && source "$ZDOTDIR/options.zsh"
[[ -f "$ZDOTDIR/exports.zsh"   ]] && source "$ZDOTDIR/exports.zsh"
[[ -f "$ZDOTDIR/aliases.zsh"   ]] && source "$ZDOTDIR/aliases.zsh"
[[ -f "$ZDOTDIR/functions.zsh" ]] && source "$ZDOTDIR/functions.zsh"

# ─── Prompt ─────────────────────────────────────────────────────────────
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
