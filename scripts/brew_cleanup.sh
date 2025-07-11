#!/bin/zsh
set -euo pipefail

echo "🔍 Running Homebrew cleanup..."

# Show current space usage
brew list --formula | wc -l | xargs echo "📦 Installed formulae:"
brew list --cask | wc -l | xargs echo "🧳 Installed casks:"
brew cleanup --dry-run -v | grep -E '^==>|^Removing' || echo "✅ Nothing to clean."

# Actually clean up old versions
echo "🧹 Cleaning up outdated brews..."
brew cleanup -s -v

# Remove orphaned dependencies (brew autoremove is new)
if brew autoremove --help &>/dev/null; then
  echo "🚮 Autoremoving unused dependencies..."
  brew autoremove -v
else
  echo "❗ 'brew autoremove' not supported on this version."
fi

# Update metadata cache
echo "🔄 Updating brew cache..."
brew update --quiet

# Upgrade everything, including casks and dependencies
echo "⬆️ Upgrading everything (formulae + casks)..."
brew upgrade --greedy --verbose

# Diagnose lingering issues
echo "🩺 Final brew doctor scan:"
brew doctor || echo "⚠️ Brew doctor found issues — review manually."

echo "✅ Done cleaning up Homebrew."
