# ── mkcd: make dir + cd ─────────────────────────────────────────────────
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# ── project jump (adjust base dir if you want) ─────────────────────────
cproj() {
  cd "$HOME/Projects/$1" 2>/dev/null || {
    echo "No such project: $1" >&2
    return 1
  }
}

# ── global update runner ────────────────────────────────────────────────
update_all() {
  echo "🔁 Updating Homebrew..."
  if command -v brew >/dev/null 2>&1; then
    brew update && brew upgrade && brew cleanup
  else
    echo "⚠️  brew not found"
  fi

  if command -v mas >/dev/null 2>&1; then
    echo "🔁 Updating Mac App Store apps..."
    mas upgrade || true
  fi

  if command -v znap >/dev/null 2>&1; then
    echo "🔁 Updating znap-managed plugins..."
    znap pull
  fi

  if [[ -d "$HOME/.dotfiles/.git" ]]; then
    echo "🔁 Pulling latest dotfiles..."
    git -C "$HOME/.dotfiles" pull --rebase --autostash || true
  fi

  echo "✅ All done."
}

# ── quick “go to dotfiles” ─────────────────────────────────────────────
cdf() {
  cd "$HOME/.dotfiles"
}