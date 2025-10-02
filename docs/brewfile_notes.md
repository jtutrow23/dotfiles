# 🍺 Brewfile Notes

## Purpose
This Brewfile installs all CLI tools, casks, and MAS apps for macOS rebuilds.

## Usage
cd ~/dotfiles
brew bundle

## Notes
- Keep taps grouped at the top.
- Separate sections for:
  - CLI tools (brew "...")
  - Casks (cask "...")
  - Mac App Store apps (mas "...")
- Comment inline for context, e.g. why you picked a formula.

## Tips
- After changes, regenerate with:
  brew bundle dump --force --file=~/dotfiles/Brewfile
- Re-run `brew bundle cleanup` to prune unused installs.
