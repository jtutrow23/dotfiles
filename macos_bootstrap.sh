#!/usr/bin/env zsh
set -euo pipefail

echo "🍏 Applying macOS defaults (safe baseline)..."

# ---- Finder ----
# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Keep folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Default to list view in Finder windows
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Show Path bar and Status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Disable .DS_Store on network/USB
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ---- Dock ----
# Auto-hide Dock
defaults write com.apple.dock autohide -bool true
# Remove auto-hide delay
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
# Minimize windows into app icon
defaults write com.apple.dock minimize-to-application -bool true
# Show only active apps (optional)
# defaults write com.apple.dock static-only -bool true

# ---- Keyboard & Typing ----
# Faster key repeat (cautious values)
defaults write NSGlobalDomain InitialKeyRepeat -int 20   # 225ms
defaults write NSGlobalDomain KeyRepeat -int 2           # ~30ms
# Disable press-and-hold in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Disable smart quotes/dashes/auto-correct/period substitution
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Full keyboard access (tab through modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# ---- Trackpad / Mouse ----
# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# Natural scrolling (toggle to false if you prefer classic)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# ---- Screenshots ----
# Save to ~/Screenshots
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
# Disable shadow in window screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# ---- Safari/Chrome (privacy) ----
# Disable auto-open 'safe' files in Safari
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# ---- Power (needs sudo) ----
# Balanced defaults: tweak to taste
if command -v sudo >/dev/null 2>&1; then
  echo "🔋 pmset (sudo) — you may be prompted..."
  # On AC power
  sudo pmset -c sleep 0                 # never sleep on charger
  sudo pmset -c displaysleep 15
  sudo pmset -c disksleep 0
  # On battery
  sudo pmset -b sleep 15
  sudo pmset -b displaysleep 5
  sudo pmset -b disksleep 5
fi

# ---- Apply changes ----
for app in "Finder" "Dock"; do
  killall "$app" >/dev/null 2>&1 || true
done

echo "✅ macOS defaults applied. Some changes need re-login to fully take effect."
