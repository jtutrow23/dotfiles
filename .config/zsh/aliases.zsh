# --- File management (eza replaces ls)
if command -v eza >/dev/null; then
  alias l='eza -l --icons --group'
  alias ll='eza -lgh --icons --group'
  alias la='eza -la --icons --group'
  alias lt='eza -lT --icons --group --level=2'
else
  alias l='ls -l'
  alias ll='ls -lh'
  alias la='ls -la'
  alias lt='ls -lR'
fi

# --- Quality of life
alias ..='cd ..'
alias ...='cd ../..'
alias please='sudo'
alias cat='bat'
alias v='nvim'
alias fz='fzf'
alias lg='lazygit'

# --- Git shortcuts
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate'
alias gc='git commit'

# --- Mackup shortcuts
alias mbackup='mackup backup --force'
alias mrestore='mackup restore --force'
alias mcheck='echo "\n📦 Mackup config:"; cat ~/.config/mackup/mackup.cfg 2>/dev/null; \
              echo "\n📂 Store tree:"; find ~/Documents/Configs/Mackup -maxdepth 2 -type d'