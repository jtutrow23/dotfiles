#!/usr/bin/env bash

# Set environment variables
export PATH="$HOME/bin:$HOME/scripts:/opt/homebrew/bin:$PATH"
export EDITOR="nvim"
export SHELL="/bin/zsh"

# Homebrew shell integration
if command -v brew &>/dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Additional setup
echo "Environment setup complete. Paths and editor set."
