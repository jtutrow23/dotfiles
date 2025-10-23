# --- Git helpers
gclean() {
  echo "🧹 Cleaning untracked files..."
  git clean -fdX
  echo "✅ Done."
}

gpush() {
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  echo "⬆️  Pushing to origin/$branch..."
  git push -u origin "$branch"
}

# --- fzf + zoxide navigators
vfind() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always {} | head -200') || return
  [[ -n "$file" ]] && nvim "$file"
}

cdp() {
  local dir
  dir=$(zoxide query -l | fzf --height 40% --reverse --prompt="📁 Jump to> ") || return
  [[ -n "$dir" ]] && cd "$dir" || return
}

# --- System utilities
reload() {
  echo "🔄 Reloading shell..."
  exec zsh
}

flushdns() {
  echo "🧠 Flushing DNS cache..."
  sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder
  echo "✅ DNS cache flushed."
}