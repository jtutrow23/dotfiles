#!/usr/bin/env bash
set -Eeuo pipefail

UNSAFE=false
UPDATE=false

status() {
  printf '\n==> %s\n' "$1"
}

usage() {
  cat <<'EOF'
Usage: defaults.sh [options]

Apply macOS defaults.

Options:
  --update    Run Homebrew + Mac App Store updates after applying defaults.
  --unsafe    Also apply security-reducing settings.
  -h, --help  Show this help.
EOF
}

while (($#)); do
  case "$1" in
    --update) UPDATE=true ;;
    --unsafe) UNSAFE=true ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This script is intended for macOS only.\n' >&2
  exit 1
fi

# Keyboard and text
status "Applying keyboard and text preferences"

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Trackpad and scrolling
status "Applying trackpad and scrolling preferences"

defaults write -g com.apple.swipescrolldirection -bool false
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Windows and dialogs
status "Applying window and dialog preferences"

defaults write -g AppleWindowTabbingMode -string "always"
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Dock
status "Applying Dock preferences"

defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock show-process-indicators -bool false
defaults write com.apple.dock persistent-apps -array

# Finder
status "Applying Finder preferences"

defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write com.apple.finder FXInfoPanesExpanded -dict MetaData -bool true Preview -bool false

# Safari
status "Applying Safari preferences"

defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtras -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

# Login banner
status "Suppressing the macOS login banner"

touch "$HOME/.hushlogin"

# Optional security reductions
if [[ "$UNSAFE" == true ]]; then
  status "Applying --unsafe settings"

  defaults write com.apple.LaunchServices LSQuarantine -bool false
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
  defaults write com.apple.CrashReporter DialogType -string "none"

  if command -v spctl >/dev/null 2>&1; then
    status "Requesting Gatekeeper disable"
    sudo spctl --master-disable || true
  fi
fi

# Optional software maintenance
if [[ "$UPDATE" == true ]]; then
  status "Running software maintenance"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  if command -v brew >/dev/null 2>&1; then
    brew update
    brew upgrade --greedy-auto-updates
    brew cleanup --prune=all
  else
    status "Homebrew not installed; skipping Homebrew maintenance"
  fi

  if command -v mas >/dev/null 2>&1; then
    mas upgrade
  else
    status "mas not installed; skipping Mac App Store upgrades"
  fi
fi

# Restart affected services
status "Restarting Dock and Finder"

for service in Dock Finder; do
  if /usr/bin/pgrep -x "$service" >/dev/null 2>&1; then
    /usr/bin/killall "$service" >/dev/null 2>&1 || true
  fi
done

status "Done"
printf 'Some preferences may require reopening apps or logging out/in.\n'
