# Prefer bat as cat if available
if command -v bat >/dev/null 2>&1; then
  alias cat='bat -pp'
fi

# Git: quick graph
alias gg='git log --graph --decorate --oneline --all --color'

# Git: clean merged local branches (keeps main/master/develop)
gclean() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not a git repo"; return 1; }
  git branch --merged 2>/dev/null | egrep -v '^\*|main$|master$|develop$' | xargs -r git branch -d
}

# Open origin repo in browser
gopen() {
  local url
  url=$(git -C "${1:-.}" remote -v | awk '/^origin[[:space:]].*(git@|https:)/{print $2; exit}') || return
  url=$(echo "$url" | sed -E 's#git@github.com:#https://github.com/#; s#\.git$##')
  [[ -n "$url" ]] && open "$url"
}

# zoxide helpers (interactive jump)
if command -v zoxide >/dev/null 2>&1; then
  zjump() { local d; d=$(zoxide query -l | fzf) || return; cd "$d" || return; }
  alias zj='zjump'
fi

# Brew helpers
bup() { brew update && brew upgrade && brew cleanup -s && brew doctor; }
bri() { brew info "$@"; }
bfind() { brew search "$1" | fzf; }

# Quick HTTP server in current dir
serve() { local p="${1:-8000}"; python3 -m http.server "$p"; }

# Safer rm (asks once per file)
alias rm='rm -I'
