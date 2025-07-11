# ~/dotfiles/zsh/functions.zsh

# Create and enter a directory
mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

# Extract various archive types
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)  tar xjf "$1"    ;;
      *.tar.gz)   tar xzf "$1"    ;;
      *.bz2)      bunzip2 "$1"    ;;
      *.rar)      unrar x "$1"    ;;
      *.gz)       gunzip "$1"     ;;
      *.tar)      tar xf "$1"     ;;
      *.tbz2)     tar xjf "$1"    ;;
      *.tgz)      tar xzf "$1"    ;;
      *.zip)      unzip "$1"      ;;
      *.Z)        uncompress "$1" ;;
      *.7z)       7z x "$1"       ;;
      *) echo "❌ Don't know how to extract: '$1'" ;;
    esac
  else
    echo "❌ '$1' is not a valid file!"
  fi
}
