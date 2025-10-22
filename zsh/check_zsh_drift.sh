#!/usr/bin/env bash
set -euo pipefail

echo "ZSH DRIFT CHECK — $(date)"
echo "SHELL: ${SHELL:-}"
echo "ZDOTDIR: ${ZDOTDIR:-$HOME/.config/zsh}"
echo

# 1) Unexpected dotfiles in $HOME (allow .zshenv)
echo "1) Unexpected dotfiles in \$HOME:"
FOUND="$(ls -A ~ | grep -E '^\.(zsh(rc|login|profile)|zcompdump|zsh_history(\.zwc|\.zwc\.old)?)$' || true)"
if [[ -n "$FOUND" ]]; then
  echo "$FOUND"
else
  echo "  none"
fi

echo
# 2) ~/.config/zsh should be a symlink to ~/dotfiles/zsh
echo "2) Non-symlink ~/.config/zsh (should be symlink to ~/dotfiles/zsh):"
if [[ -L "$HOME/.config/zsh" ]]; then
  ls -ld "$HOME/.config/zsh"
else
  echo "  NOT a symlink — fix with: ln -snf ~/dotfiles/zsh ~/.config/zsh"
fi

echo
# 3) Compiled caches in ZDOTDIR
echo "3) Compiled caches in ZDOTDIR:"
find "${ZDOTDIR:-$HOME/.config/zsh}" -maxdepth 1 -name '*.zwc' -print || echo "  none"

echo
# 4) Plugin path present?
echo "4) Plugin path:"
[[ -r "$HOME/.zsh_plugins/znap/znap.zsh" ]] && echo "  OK: ~/.zsh_plugins present" || echo "  MISSING: znap bootstrap"

echo
# 5) Trash/backups
echo "5) Trash/backups:"
ls -A ~/.Trash | grep -E '(zsh|zwc|aliases|functions|exports|options)' || echo "  none"