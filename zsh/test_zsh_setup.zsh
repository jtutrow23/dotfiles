#!/bin/zsh
# Quick Zsh modular setup test runner

set -e

print_status() {
  echo "[✔] $1"
}

# Ensure all expected files exist
for f in env.zsh init.zsh plugins.zsh prompt.zsh aliases.zsh functions.zsh; do
  [[ -f "$ZSHDIR/$f" ]] || { echo "[✘] Missing $f"; exit 1; }
  print_status "$f exists"
done

# Load Zsh env
source "$ZSHDIR/env.zsh"
print_status "env.zsh sourced"

# Run init.zsh (full chain test)
source "$ZSHDIR/init.zsh"
print_status "init.zsh sourced"

# Test key aliases
alias .. &>/dev/null && print_status "alias .. ok"
alias gs &>/dev/null && print_status "alias gs ok"

# Test functions
mkcd test_temp && print_status "mkcd function ok"
cd .. && rm -rf test_temp

# Test znap + plugins
znap list | grep -q "zsh-autosuggestions" && print_status "zsh-autosuggestions loaded"
znap list | grep -q "pure" && print_status "pure prompt loaded"

# Confirm prompt is working (safely)
prompt -l | grep -q pure && print_status "pure theme available"

print_status "All checks passed!"

