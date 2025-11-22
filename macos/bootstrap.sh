#!/usr/bin/env bash
set -euo pipefail

echo "──────────────────────────────────────────"
echo "🚀  Bootstrapping macOS with jtutrow23/dotfiles"
echo "──────────────────────────────────────────"

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
  NONINTERACTIVE=1 \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Load into environment
eval "$(/opt/homebrew/bin/brew shellenv)"
echo "✔️  Homebrew available at: $(command -v brew)"

################################################################################
# 3. HOMEBREW PACKAGES (Brewfile)
################################################################################
if [[ -f "$HOME/.dotfiles/Brewfile" ]]; then
  echo "📚 Installing packages from Brewfile…"
  brew bundle --file="$HOME/.dotfiles/Brewfile"
  echo "✔️  Brewfile packages installed"
else
  echo "⚠️  No Brewfile found, skipping package installation"
fi

################################################################################
# 4. SYMLINK DOTFILES USING STOW
################################################################################
if ! command -v stow >/dev/null; then
  echo "⚙️ Installing stow…"
  brew install stow
fi

echo "🔗 Stowing dotfiles…"
cd "$HOME/.dotfiles"

stow zsh
stow starship
[[ -d macos ]] && stow macos

echo "✔️  Dotfiles deployed"

################################################################################
# 5. SHELL DEFAULTS (Zsh + Starship)
################################################################################
if command -v zsh >/dev/null; then
  echo "🔧 Ensuring zsh is default shell…"
  chsh -s "$(command -v zsh)" || true
fi
echo "✔️  Default shell set"

################################################################################
# 6. macOS SYSTEM TWEAKS (optional)
################################################################################
if [[ -x "$HOME/.dotfiles/macos/defaults.sh" ]]; then
  echo "🛠 Applying macOS system defaults…"
  "$HOME/.dotfiles/macos/defaults.sh"
  echo "✔️  macOS defaults applied"
fi

################################################################################
# 7. FINISH
################################################################################
echo "──────────────────────────────────────────"
echo "🎉 macOS bootstrap complete!"
echo "Restart your terminal to activate everything."
echo "──────────────────────────────────────────"
