# ── ls / eza ────────────────────────────────────────────────────────────
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -lh --git --group-directories-first'
  alias la='eza -lha --group-directories-first'
else
  alias ls='ls -FG'
  alias ll='ls -lah'
  alias la='ls -lah'
fi

# ── Navigation ──────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── Git ─────────────────────────────────────────────────────────────────
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpl='git pull --rebase --autostash'

# ── Brew ────────────────────────────────────────────────────────────────
alias b='brew'
alias bu='brew update && brew upgrade && brew cleanup'

# ── Editing ────────────────────────────────────────────────────────────
alias v='nvim'
alias nv='nvim'