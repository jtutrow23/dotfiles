#!/usr/bin/env bash
set -euo pipefail

echo "──────────────────────────────────────────"
echo "🚀  Bootstrapping macOS with jtutrow23/dotfiles"
echo "──────────────────────────────────────────"

################################################################################
# 0. SANITY CHECKS
################################################################################

# Must be run from an admin user (but NOT as root)
if [[ "$(id -u)" -eq 0 ]]; then
  echo "❌ Do NOT run this as root. Run it as your normal user."
  exit 1
fi

if ! id -Gn | grep -q '\badmin\b'; then
  echo "❌ This user is not in the admin group. Homebrew install will fail."
  echo "   Fix account privileges, then re-run."
  exit 1
fi

# Dotfiles repo must exist
if [[ ! -d "$HOME/.dotfiles" ]]; then
  echo "❌ ~/.dotfiles does not exist."
  echo "   Clone your repo first, e.g.:"
  echo "     git clone git@github.com:jtutrow23/dotfiles.git ~/.dotfiles"
  exit 1
fi

cd "$HOME/.dotfiles"

################################################################################
# 1. XCODE COMMAND LINE TOOLS
################################################################################
if ! xcode-select -p &>/dev/null; then
  echo "📦 Installing Xcode Command Line Tools…"
  xcode-select --install || true

  echo "⏳ Waiting for CLT install to finish…"
  until xcode-select -p &>/dev/null; do
    sleep 10
  done
fi
echo "✔️  Xcode Command Line Tools installed"

################################################################################
# 2. HOMEBREW
################################################################################
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew…"
  # NONINTERACTIVE stops brew asking questions, but sudo can still prompt you
  NONINTERACTIVE=1 \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Load into environment for THIS script
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "❌ Homebrew didn't end up at /opt/homebrew/bin/brew. Aborting."
  exit 1
fi

echo "✔️  Homebrew available at: $(command -v brew)"

################################################################################
# 3. HOMEBREW PACKAGES (Brewfile)
################################################################################
BREWFILE="$HOME/.dotfiles/Brewfile"

if [[ -f "$BREWFILE" ]]; then
  echo "📚 Installing packages from Brewfile…"
  # Don’t explode the whole bootstrap if Brewfile has a few bad entries
  if ! brew bundle --file="$BREWFILE"; then
    echo "⚠️  brew bundle reported errors. Check the output above."
  else
    echo "✔️  Brewfile packages installed"
  fi
else
  echo "⚠️  No Brewfile found at $BREWFILE, skipping package installation"
fi

################################################################################
# 4. SYMLINK DOTFILES USING STOW
################################################################################
if ! command -v stow >/dev/null 2>&1; then
  echo "⚙️ Installing stow…"
  brew install stow
fi

echo "🔗 Stowing dotfiles…"
# Remove any old links first to keep things clean
stow -D zsh starship 2>/dev/null || true

stow zsh
stow starship
[[ -d macos ]] && stow macos

echo "✔️  Dotfiles deployed"

################################################################################
# 5. SHELL DEFAULTS (Zsh + Starship)
################################################################################
if command -v zsh >/dev/null 2>&1; then
  ZSH_BIN="$(command -v zsh)"
  echo "🔧 Ensuring zsh is default shell ($ZSH_BIN)…"

  # Make sure zsh is in /etc/shells
  if ! grep -qx "$ZSH_BIN" /etc/shells; then
    echo "➕ Adding $ZSH_BIN to /etc/shells (requires sudo)…"
    echo "$ZSH_BIN" | sudo tee -a /etc/shells >/dev/null
  fi

  chsh -s "$ZSH_BIN" || echo "⚠️  chsh failed (maybe non-interactive shell); continue manually if needed."
fi
echo "✔️  Default shell step done"

################################################################################
# 6. macOS SYSTEM TWEAKS (optional)
################################################################################
if [[ -x "$HOME/.dotfiles/macos/defaults.sh" ]]; then
  echo "🛠 Applying macOS system defaults…"
  "$HOME/.dotfiles/macos/defaults.sh"
  echo "✔️  macOS defaults applied"
else
  echo "ℹ️  No macOS defaults script found (macos/defaults.sh is not executable or missing)."
fi

################################################################################
# 7. FINISH
################################################################################
echo "──────────────────────────────────────────"
echo "🎉 macOS bootstrap complete!"
echo "➡️  Close this Terminal window and open a new one to start in the fresh zsh + starship environment."
echo "──────────────────────────────────────────"
