#!/bin/zsh
set -euo pipefail

echo "🔄 Updating Homebrew..."
brew update

echo "📦 Upgrading Homebrew packages (including greedy auto updates)..."
brew upgrade --greedy-auto-updates

echo "🧹 Cleaning up old Homebrew versions..."
brew cleanup --prune=all

echo "🛍 Upgrading Mac App Store apps via mas..."
mas upgrade

echo
echo "🧪 Checking for installed beta/nightly casks..."
brew list --cask | grep -E '(-beta|-nightly|-alpha)' || echo "✅ No beta/nightly casks installed."

echo
echo "🔍 Checking for available beta/nightly for installed stable casks..."
for app in $(brew list --cask); do
  for suffix in beta nightly alpha; do
    if brew search --casks "${app}-${suffix}" | grep -q "^${app}-${suffix}\$"; then
      echo "➡️  Beta available for '${app}': install via 'brew install --cask ${app}-${suffix}'"
    fi
  done
done

echo
echo "🔗 Checking public TestFlight beta lists..."
TF_LIST_URL="https://raw.githubusercontent.com/pluwen/awesome-testflight-link/main/db/ios.json"
if curl -sSL "$TF_LIST_URL" >/tmp/tf.json; then
  echo "✅ Fetched public TestFlight beta list."
  mas list | awk '{print $NF}' | while read -r bundle; do
    jq -r --arg b "$bundle" '.[] | select(.bundleId==$b) | "\(.name): \(.link) [\(.status)]"' /tmp/tf.json
  done
else
  echo "⚠️ Could not fetch TestFlight list from GitHub."
fi

echo
echo "ℹ️ Done. You may want to use 'push-alert' if any alerts need sending."
