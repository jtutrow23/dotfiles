#!/usr/bin/env bash
# system_tools.sh — Unified, optimized maintenance toolkit

# Usage: system_tools.sh <command> [options]
# Commands:
#   net-reset     Reset DNS cache & renew DHCP lease
#   refresh       Refresh system caches (QuickLook, LS, purge)
#   sip-fix       Fix Homebrew & Library permissions
#   help          Show usage

set -euo pipefail
IFS=$'\n\t'

# Defaults
NET_IFACE="en0"
DRYRUN=false

usage(){
  grep '^#' "$0" | sed -e 's/^#//'
}

# net-reset: flush DNS + DHCP
net_reset(){
  while getopts ":i:d" opt; do
    case $opt in
      i) NET_IFACE="$OPTARG" ;;
      d) DRYRUN=true ;;
      *) echo "Invalid option for net-reset"; exit 1 ;;
    esac
  done
  echo "🔄 Network reset on $NET_IFACE (dry-run=$DRYRUN)"
  $DRYRUN && echo "DRY: dscacheutil -flushcache" || sudo dscacheutil -flushcache
  $DRYRUN && echo "DRY: killall -HUP mDNSResponder" || sudo killall -HUP mDNSResponder
  $DRYRUN && echo "DRY: ipconfig set $NET_IFACE DHCP" || sudo ipconfig set "$NET_IFACE" DHCP
  echo "✅ Network reset complete"
}

# refresh: QuickLook + LaunchServices + purge
refresh_system(){
  echo "🔧 Refreshing caches"
  qlmanage -r cache
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -kill -r -domain local -domain user
  if command -v purge &>/dev/null; then sudo purge; fi
  echo "✅ Caches refreshed"
}

# sip-fix: chown/chmod on key directories
sip_fix(){
  dirs=( "/opt/homebrew" \
         "$HOME/Library/Fonts" \
         "$HOME/Library/Trial" \
         "$HOME/Library/Group Containers/group.com.apple.secure-control-center-preferences" )
  for d in "${dirs[@]}"; do
    if [[ -e $d ]]; then
      echo "🛠 Fixing $d"
      sudo chown -R "$USER":staff "$d"
      find "$d" -type d -exec chmod 755 {} +
      find "$d" -type f -exec chmod 644 {} +
    else
      echo "⚠️  $d not found, skipping"
    fi
  done
  echo "✅ Permissions fixed"
}

# Dispatch
case ${1:-help} in
  net-reset)  shift; net_reset "$@" ;;
  refresh)    shift; refresh_system ;;
  sip-fix)    shift; sip_fix ;;
  help|*)     usage     ;;
esac
