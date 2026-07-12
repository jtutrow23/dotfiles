#!/bin/bash
#
# icloud-sync-reset.sh
#
# Non-destructive reset of macOS user-level iCloud sync services.
# Run as your normal logged-in user. DO NOT run with sudo.
#

set -Eeuo pipefail

if [[ $EUID -eq 0 ]]; then
    echo "ERROR: Run this as your normal user, not with sudo."
    exit 1
fi

UID_NUM="$(id -u)"
STAMP="$(date '+%Y%m%d-%H%M%S')"
LOG_DIR="$HOME/Desktop/iCloud-Sync-Reset-$STAMP"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_DIR/reset.log") 2>&1

echo "=========================================="
echo " macOS iCloud Sync Service Reset"
echo "=========================================="
echo "User:    $USER"
echo "UID:     $UID_NUM"
echo "macOS:   $(sw_vers -productVersion)"
echo "Build:   $(sw_vers -buildVersion)"
echo "Started: $(date)"
echo

echo "[1/7] Capturing current process state..."

pgrep -alf \
'accountsd|akd|apsd|bird|cloudd|homed|imagent|identityservicesd|nsurlsessiond|password|securityd|sharingd|trustd|ubd' \
> "$LOG_DIR/processes-before.txt" 2>&1 || true

launchctl print "gui/$UID_NUM" \
> "$LOG_DIR/launchctl-user-before.txt" 2>&1 || true

echo "[2/7] Closing apps that may hold stale sync sessions..."

osascript -e 'tell application "Home" to quit' 2>/dev/null || true
osascript -e 'tell application "Messages" to quit' 2>/dev/null || true
osascript -e 'tell application "Passwords" to quit' 2>/dev/null || true
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true
osascript -e 'tell application "Safari" to quit' 2>/dev/null || true

sleep 3

echo "[3/7] Restarting user-level iCloud and authentication processes..."

USER_PROCESSES=(
    accountsd
    akd
    apsd
    bird
    cloudd
    homed
    imagent
    identityservicesd
    nsurlsessiond
    PasswordBreachAgent
    passwords
    sharingd
    trustd
    ubd
)

for process in "${USER_PROCESSES[@]}"; do
    if pgrep -u "$UID_NUM" -x "$process" >/dev/null 2>&1; then
        echo "Restarting: $process"
        pkill -u "$UID_NUM" -x "$process" 2>/dev/null || true
    else
        echo "Not currently running: $process"
    fi
done

echo "[4/7] Restarting the per-user security service..."

# Targets only the current user's instance, not the root/system instance.
pkill -u "$UID_NUM" -x securityd 2>/dev/null || true

sleep 3

echo "[5/7] Asking launchd to restart known user agents..."

AGENTS=(
    com.apple.accountsd
    com.apple.akd
    com.apple.apsd
    com.apple.bird
    com.apple.cloudd
    com.apple.homed
    com.apple.imagent
    com.apple.identityservicesd
    com.apple.nsurlsessiond
    com.apple.sharingd
    com.apple.trustd
    com.apple.ubd
)

for label in "${AGENTS[@]}"; do
    if launchctl print "gui/$UID_NUM/$label" >/dev/null 2>&1; then
        echo "Kickstarting: $label"
        launchctl kickstart -k "gui/$UID_NUM/$label" 2>/dev/null || true
    else
        echo "Label unavailable on this macOS build: $label"
    fi
done

echo "[6/7] Clearing only disposable caches..."

SAFE_CACHES=(
    "$HOME/Library/Caches/CloudKit"
    "$HOME/Library/Caches/com.apple.Home"
    "$HOME/Library/Caches/com.apple.Passwords"
    "$HOME/Library/Caches/com.apple.accountsd"
    "$HOME/Library/Caches/com.apple.cloudd"
)

for cache in "${SAFE_CACHES[@]}"; do
    if [[ -e "$cache" ]]; then
        echo "Removing cache: $cache"
        rm -rf "$cache"
    fi
done

echo "[7/7] Capturing fresh state..."

sleep 8

pgrep -alf \
'accountsd|akd|apsd|bird|cloudd|homed|imagent|identityservicesd|nsurlsessiond|password|securityd|sharingd|trustd|ubd' \
> "$LOG_DIR/processes-after.txt" 2>&1 || true

log show \
    --last 5m \
    --style compact \
    --predicate '
        process == "accountsd" OR
        process == "akd" OR
        process == "cloudd" OR
        process == "homed" OR
        process == "securityd" OR
        process == "trustd"
    ' \
    > "$LOG_DIR/recent-sync-logs.txt" 2>&1 || true

echo
echo "Reset completed."
echo "Logs saved in:"
echo "  $LOG_DIR"
echo
echo "Restart the Mac now."
echo
echo "IMPORTANT:"
echo "Do not delete ~/Library/Keychains,"
echo "CloudKit databases, keychain-2.db,"
echo "or HomeKit configuration files."