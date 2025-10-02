# ⚙️ Dotfiles Setup Guide

## 1. Clone repo
git clone git@github.com:jtutrow23/dotfiles.git ~/dotfiles

## 2. Symlinks + Bootstrap
zsh ~/dotfiles/setup_dotfiles.sh
- Links .zshrc, .zshenv, configs into ~/.config/

## 3. Install Homebrew apps
brew bundle --file=~/dotfiles/Brewfile

## 4. Apply macOS defaults
zsh ~/dotfiles/macos_bootstrap.sh

## 5. Verify
warm    # precompile Znap
exec zsh
