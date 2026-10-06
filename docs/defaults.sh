# -----------------------------------------------------------------------------
# Keyboard and text input
# -----------------------------------------------------------------------------
status 'Applying keyboard and text preferences'

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# -----------------------------------------------------------------------------
# Window tabbing
# -----------------------------------------------------------------------------
status 'Applying window tabbing preference'

defaults write -g AppleWindowTabbingMode -string always

# -----------------------------------------------------------------------------
# Dock
# -----------------------------------------------------------------------------
status 'Applying Dock preferences'

defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock show-process-indicators -bool false

# Clear pinned applications with an empty array.
defaults write com.apple.dock persistent-apps -array

# -----------------------------------------------------------------------------
# Finder and terminal login banner
# -----------------------------------------------------------------------------
status 'Showing hidden files and suppressing the login banner'

defaults write com.apple.finder AppleShowAllFiles -bool true

if [[ ! -e "$HOME/.hushlogin" ]]; then
  touch "$HOME/.hushlogin"
fi

# -----------------------------------------------------------------------------
# Optional settings: --unsafe
# -----------------------------------------------------------------------------
# WARNING: disables the listed quarantine and disk image verification settings.
# The supplied CrashReporter command had no visible string value; use "".
# No Gatekeeper change was included in the supplied commands.
if "$UNSAFE"; then
  status 'Applying --unsafe settings'

  defaults write com.apple.LaunchServices LSQuarantine -bool false

  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

  defaults write com.apple.CrashReporter DialogType -string ''
fi

# -----------------------------------------------------------------------------
# Optional Homebrew and Mac App Store maintenance: --update
# -----------------------------------------------------------------------------
if "$UPDATE"; then
  status 'Running software maintenance'

  if [[ -x /opt/homebrew/bin/brew ]]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  fi

  if command -v brew >/dev/null 2>&1; then
    brew update
    brew upgrade --greedy-auto-updates
    brew cleanup --prune=all
  else
    status 'Homebrew not installed; skipping'
  fi

  if command -v mas >/dev/null 2>&1; then
    mas upgrade
  else
    status 'mas not installed; skipping'
  fi
fi

# -----------------------------------------------------------------------------
# Restart affected services
# -----------------------------------------------------------------------------
status 'Restarting Dock and Finder'

for service in Dock Finder; do
  if /usr/bin/pgrep -u "$UID" -x "$service" >/dev/null; then
    /usr/bin/killall -u "$(id -un)" "$service"
  fi
done

status 'Done. Restart other apps or log out/in for remaining preferences.'
