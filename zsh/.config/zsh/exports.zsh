# ── Locale ──────────────────────────────────────────────────────────────
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ── Editor / Pager ──────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less -FRX"
export LESSHISTFILE="-"   # don't litter with less history files

# ── SSH via 1Password (if available) ────────────────────────────────────
if [[ -S "$HOME/.1password/agent.sock" ]]; then
  export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
fi

# ── FZF / ripgrep defaults (if you add them later) ─────────────────────
if command -v rg >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git" 2>/dev/null'
fi