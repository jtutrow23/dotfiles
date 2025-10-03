# make dir then cd
mkcd() { mkdir -p -- "$1" && cd -- "$1" || return; }

# quick archive extractor (basic)
extract() {
  local f="$1"
  [[ -z "$f" || ! -f "$f" ]] && { echo "usage: extract <file>"; return 2; }
  case "$f" in
    *.tar.bz2)   tar xjf "$f"   ;;
    *.tar.gz)    tar xzf "$f"   ;;
    *.tar.xz)    tar xJf "$f"   ;;
    *.tar)       tar xf  "$f"   ;;
    *.tbz2)      tar xjf "$f"   ;;
    *.tgz)       tar xzf "$f"   ;;
    *.zip)       unzip  "$f"    ;;
    *.7z)        7z x   "$f"    ;;
    *)           echo "unknown archive: $f"; return 1 ;;
  esac
}

# update common tools (idempotent)
updateall() {
  command -v brew >/dev/null 2>&1 && brew update && brew upgrade && brew cleanup -s || true
  command -v mise >/dev/null 2>&1 && mise upgrade || true
  command -v npm  >/dev/null 2>&1 && npm -g update || true
  command -v pipx >/dev/null 2>&1 && pipx upgrade-all || true
  echo "done."
}

# Update & cleanup Homebrew
brewup() {
  echo "🍺 Updating Homebrew..."
  brew upgrade --greedy-auto-updates

  echo "⬆️  Upgrading formulae & casks..."
  brew upgrade

  echo "🧹 Cleaning up old versions..."
  brew cleanup --prune=all

  echo "✅ Homebrew is up-to-date."
}