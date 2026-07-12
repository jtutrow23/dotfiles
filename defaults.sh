# Enable press-and-hold repeating
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Disable "Natural" scrolling
defaults write -g com.apple.swipescrolldirection -bool false

# Disable smart dash/period/quote substitutions
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable automatic capitalization
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Using expanded "save panel" by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Set icon size and dock orientation
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock orientation -string left

# Set dock to auto-hide, and transparentize icons of hidden apps (⌘H)
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true

# Disable to show recents, and light-dot of running apps
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock show-process-indicators -bool false

# --- Unpin all apps
defaults write com.apple.dock persistent-apps -array ""

# Allow quitting via ⌘Q
defaults write com.apple.finder QuitMenuItem -bool true

# Disable warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show all files and their extensions
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar, and layout as multi-column
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string clmv

# Search in current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

# --- Keep the desktop clean
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Show directories first
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# New window use the $HOME path
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Show metadata info, but not preview in info panel
defaults write com.apple.finder FXInfoPanesExpanded -dict MetaData -bool true Preview -bool false

# Enable trackpad tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Enable 3-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Disable quarantine for downloaded apps
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable auto open downloads
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Enable Develop Menu, Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtras -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Disable crash reporter
defaults write com.apple.CrashReporter DialogType -string none
defaults write com.apple.CrashReporter DialogType -string none

sudo spctl --master-disable
