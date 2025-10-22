mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

extract() {
  local file="$1"
  [[ -f "$file" ]] || { print -r -- "'$file' is not a file"; return 1; }
  case "$file" in
    *.tar.bz2|*.tbz2) tar xjf "$file" ;;
    *.tar.gz|*.tgz)   tar xzf "$file" ;;
    *.tar.xz)         tar xJf "$file" ;;
    *.tar)            tar xf "$file" ;;
    *.zip)            unzip -q "$file" ;;
    *.7z)             7z x "$file" ;;
    *.rar)            unrar x "$file" ;;
    *)                print -r -- "'$file' has unknown format"; return 2 ;;
  esac
}

reload() { source "$ZDOTDIR/zshrc" && print -P "%F{green}🔁 Zsh reloaded%f"; }
