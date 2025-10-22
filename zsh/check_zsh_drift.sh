#!/usr/bin/env bash
set -euo pipefail

echo "ZSH DRIFT CHECK — $(date)"
echo "SHELL: ${SHELL:-}"
echo "ZDOTDIR: ${ZDOTDIR:-$HOME/.config/zsh}"
echo

echo "1) Unexpected dotfiles in \$HOME:"
ls -A ~ | grep -E '^\.(zsh(rc|env|login|profile)|zcompdump|zsh_history(\.zwc|\.zwc\.old)?)$' || echo "  none"

echo
echo "2) Non-symlink ~/.config/zsh (should be symlink to ~/dotfiles/zsh):"
if [ -L "$HOME/.config/zsh" ]; then
  ls -ld "$HOME/.config/zsh"
else
  echo "  NOT a symlink — consider: ln -snf ~/dotfiles/zsh ~/.config/zsh"
fi

echo
echo "3) Compiled caches in ZDOTDIR:"
find "${ZDOTDIR:-$HOME/.config/zsh}" -maxdepth 1 -name '*.zwc' -print || true

echo
echo "4) Plugin path:"
test -r "$HOME/.zsh_plugins/znap/znap.zsh" && echo "  OK: ~/.zsh_plugins present" || echo "  MISSING: znap bootstrap"

echo
echo "5) Trash/backups:"
ls -A ~/.Trash | grep -E '(zsh|zwc|aliases|functions|exports|options)' || echo "  none"
