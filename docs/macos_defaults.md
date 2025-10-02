# 🍏 macOS Defaults (Explained)

This document explains each tweak in `macos_bootstrap.sh`.

## Usage
zsh ~/dotfiles/macos_bootstrap.sh

Some changes require logout/restart.

---

## Finder
- Show all extensions, keep folders on top, list view default.
- Path/status bars visible.
- No .DS_Store on network/USB drives.

## Dock
- Auto-hide with no delay and fast animation.
- Minimize into app icons.
- (Optional) Only show active apps.

## Keyboard & Typing
- Faster key repeat (safe values).
- Disable press-and-hold accents.
- Turn off smart quotes, dashes, autocorrect, period substitution.
- Tab through all modal dialogs.

## Trackpad / Mouse
- Tap to click enabled.
- Natural scrolling (set false for classic scroll).

## Screenshots
- Saved to ~/Screenshots.
- Window shadows disabled.

## Safari/Chrome
- Disable auto-open of “safe” downloads.

## Power (sudo/pmset)
- On charger: no sleep, display off after 15m.
- On battery: sleep 15m, display off 5m.

## Apply
Script restarts Finder and Dock automatically.

## Philosophy
- Baseline tweaks = safe, useful, reversible.
- No brittle or obscure settings.
