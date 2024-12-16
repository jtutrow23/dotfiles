#!/bin/zsh
echo "🔄 Updating Homebrew..."
brew update && brew upgrade --greedy && brew cleanup
echo "✅ Homebrew update complete!"
