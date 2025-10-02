# 🍏 macOS Defaults & Power Settings

## Purpose
Tracks all `defaults write` and `pmset` tweaks for consistent setup.

## Usage
zsh ~/dotfiles/macos_bootstrap.sh

## Common Tweaks
- Disable press-and-hold:
  defaults write -g ApplePressAndHoldEnabled -bool false
- Faster key repeat:
  defaults write -g KeyRepeat -int 1
- Expanded save/print panels:
  defaults write -g NSNavPanelExpandedStateForSaveMode -bool true

## Power
- Prevent sleep on lid close:
  sudo pmset -a disablesleep 1
- Show battery percentage:
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"
