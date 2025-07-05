#!/usr/bin/env bash
set -e

# ─── Keyboard ───────────────────────────────────────────────────────────────────
defaults write -g ApplePressAndHoldEnabled -bool false        # Disable press-and-hold
defaults write -g InitialKeyRepeat       -int 10             # Faster first repeat
defaults write -g KeyRepeat              -int 1              # Faster repeat rate

# ─── Scrolling & Gestures ──────────────────────────────────────────────────────
defaults write -g com.apple.swipescrolldirection -bool false  # Disable Natural scroll
defaults write com.apple.AppleMultitouchTrackpad Clicking    -bool true  # Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# ─── Text Substitutions ──────────────────────────────────────────────────────
defaults write -g NSAutomaticDashSubstitutionEnabled   -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled  -bool false
defaults write -g NSAutomaticCapitalizationEnabled     -bool false

# ─── Save Panels & Tabs ─────────────────────────────────────────────────────
defaults write -g NSNavPanelExpandedStateForSaveMode  -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write -g AppleWindowTabbingMode             -string always

# ─── Dock ─────────────────────────────────────────────────────────────────────
defaults write com.apple.dock show-recents               -bool false
defaults write com.apple.dock show-process-indicators    -bool false
defaults write com.apple.dock persistent-apps            -array          # Unpin all apps
defaults write com.apple.dock tilesize                   -int 48
defaults write com.apple.dock orientation                -string left
killall Dock

# ─── Finder ───────────────────────────────────────────────────────────────────
defaults write com.apple.finder QuitMenuItem                     -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning   -bool false
defaults write com.apple.finder AppleShowAllExtensions           -bool true
defaults write com.apple.finder AppleShowAllFiles                -bool true
defaults write com.apple.finder ShowPathbar                      -bool true
defaults write com.apple.finder FXPreferredViewStyle             -string clmv
defaults write com.apple.finder FXDefaultSearchScope             -string SCcf
defaults write com.apple.finder ShowHardDrivesOnDesktop          -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop      -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop  -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop      -bool false
defaults write com.apple.finder _FXSortFoldersFirst              -bool true
defaults write com.apple.finder NewWindowTarget                  -string PfHm
defaults write com.apple.finder NewWindowTargetPath              -string "file://$HOME/"
defaults write com.apple.finder QLEnableTextSelection            -bool true
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    MetaData -bool true \
    Preview  -bool false

# ─── Activity Monitor ─────────────────────────────────────────────────────────
defaults write com.apple.ActivityMonitor SortColumn      -string CPUUsage
defaults write com.apple.ActivityMonitor SortDirection   -int 0

# ─── Security & Privacy ───────────────────────────────────────────────────────
defaults write com.apple.LaunchServices LSQuarantine                    -bool false
defaults write com.apple.CrashReporter DialogType                        -string none
defaults write com.apple.AdLib forceLimitAdTracking                     -bool true
defaults write com.apple.AdLib allowApplePersonalizedAdvertising         -bool false
defaults write com.apple.AdLib allowIdentifierForAdvertising             -bool false
sudo spctl --master-disable  # Allow apps from anywhere

# ─── Safari ───────────────────────────────────────────────────────────────────
defaults write com.apple.Safari UniversalSearchEnabled                             -bool false
defaults write com.apple.Safari SuppressSearchSuggestions                          -bool true
defaults write com.apple.Safari SendDoNotTrackHTTPHeader                           -bool true
defaults write com.apple.Safari AutoOpenSafeDownloads                             -bool false
defaults write com.apple.Safari IncludeDevelopMenu                                 -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu                           -bool true
defaults write com.apple.Safari WebKitDeveloperExtras                             -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey         -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

# ─── Disk Images ──────────────────────────────────────────────────────────────
defaults write com.apple.frameworks.diskimages skip-verify         -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked  -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote  -bool true

echo "✔ All defaults written. Logout/restart apps as needed to apply."