#!/opt/homebrew/bin/zsh
# ~/dotfiles/zsh/test_login_shell.zsh

set -e
echo "🔍 Checking interactive login shell behavior..."

[[ "$SHELL" = "/opt/homebrew/bin/zsh" ]] \
  && echo "✅ Default shell is Homebrew Zsh" \
  || { echo "❌ Not using Homebrew Zsh: $SHELL"; exit 1; }

[[ -L "$HOME/.zshrc" && "$(readlink "$HOME/.zshrc")" == *init.zsh ]] \
  && echo "✅ .zshrc → init.zsh" \
  || { echo "❌ .zshrc symlink broken"; exit 1; }

zsh -il -c '
  echo "➡️  Inside simulated interactive login shell…"
  typeset -f prompt_pure >/dev/null    && echo "✅ Pure prompt loaded"
  typeset -f mkcd >/dev/null           && echo "✅ mkcd function available"
  alias gs >/dev/null                  && echo "✅ alias gs is active"
  command -v znap >/dev/null           && echo "✅ znap command available"
'
echo "🎉 Interactive login shell test passed!"
