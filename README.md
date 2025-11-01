dotfiles (Apple Silicon) — final

Minimal Zsh on Homebrew Zsh. Znap for plugins. Starship prompt. 1Password SSH agent. Tiered Brewfiles.

⸻

Structure

~/.dotfiles
├── brew/
│   ├── 01-core-min.Brewfile
│   ├── 02-dev-extras.Brewfile
│   └── 20-apps.Brewfile
├── macos/defaults.sh
├── ssh/.ssh/config          # template only; no keys
├── starship/.config/starship.toml
└── zsh/
    ├── .zprofile
    ├── .zshenv
    └── .config/zsh/
        ├── .zshrc
        ├── aliases.zsh
        ├── exports.zsh
        ├── functions.zsh
        └── options.zsh


⸻

One-time setup on a fresh Mac

# Xcode tools and Homebrew
xcode-select --install || true
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Clone repo
git clone git@github.com:YOURUSER/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install stow and shells
brew install stow zsh starship git gh mas gnupg pinentry-mac

# Remove any existing shell files, then stow
rm -f ~/.zshenv ~/.zprofile
rm -rf ~/.config/zsh
stow -R zsh starship ssh

# Make Homebrew zsh the login shell
grep -q '^/opt/homebrew/bin/zsh$' /etc/shells || echo '/opt/homebrew/bin/zsh' | sudo tee -a /etc/shells >/dev/null
chsh -s /opt/homebrew/bin/zsh

# Reload
exec /opt/homebrew/bin/zsh -l

Expected:

echo $ZDOTDIR             # /Users/<you>/.config/zsh
file ~/.config/zsh/.zshrc # symbolic link -> ~/.dotfiles/...
zsh --version             # 5.9 (arm64-apple-darwin…)


⸻

Brew tiers

Install in this order.

# core CLI and shell tools
brew bundle --file ~/.dotfiles/brew/01-core-min.Brewfile

# optional dev and media tools
brew bundle --file ~/.dotfiles/brew/02-dev-extras.Brewfile

# sign into App Store first, then apps
open -a "App Store" && mas account
brew bundle --file ~/.dotfiles/brew/20-apps.Brewfile

Cleanup and drift control:

brew bundle cleanup --force --file ~/.dotfiles/brew/01-core-min.Brewfile
brew bundle cleanup --force --file ~/.dotfiles/brew/02-dev-extras.Brewfile
brew autoremove

Note: Do not list zsh plugins as formulae. Znap manages them.

⸻

Zsh, Znap, Starship

~/.dotfiles/zsh/.config/zsh/.zshrc:

source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/exports.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"

autoload -Uz compinit && compinit -i

# Znap
if [[ ! -r ~/.znap/znap.zsh ]]; then
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/.znap
fi
source ~/.znap/znap.zsh
znap source zsh-users/zsh-autosuggestions
znap source zdharma-continuum/fast-syntax-highlighting
znap source zsh-users/zsh-completions

# Starship
command -v starship >/dev/null && eval "$(starship init zsh)"

~/.dotfiles/zsh/.zshenv:

export ZDOTDIR="$HOME/.config/zsh"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin"

~/.dotfiles/zsh/.zprofile:

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


⸻

1Password SSH agent

Template at ssh/.ssh/config:

Host github.com
  HostName github.com
  User git
  IdentityAgent ~/.1password/agent.sock
  IdentitiesOnly yes
  UseKeychain yes

Link the agent socket:

mkdir -p ~/.1password
AGENT="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
[ -S "$AGENT" ] && ln -sfn "$AGENT" ~/.1password/agent.sock || true

Test:

ssh -G github.com | grep -E 'identity(agent|file)'
ssh -T git@github.com  # should greet you

Git signing with SSH:

git config --global gpg.format ssh
git config --global gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
git config --global user.signingkey 'ssh-ed25519 AAAA...your-public-key...'
echo "you@example.com ssh-ed25519 AAAA...your-public-key..." > ~/.ssh/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
git config --global commit.gpgsign true


⸻

macOS defaults

Script placeholder at macos/defaults.sh. Make it executable and run when ready.

chmod +x ~/.dotfiles/macos/defaults.sh
~/.dotfiles/macos/defaults.sh


⸻

Working Copy / iOS flow
	•	Import repo into Working Copy.
	•	Edit with Textastic.
	•	Commit and push.
	•	On the Mac, git pull then stow -R zsh starship ssh.

⸻

Updates

brew update && brew upgrade
znap pull            # update plugins
git -C ~/.dotfiles pull


⸻

What not to commit
	•	Any private keys or ~/.ssh contents except the example config.
	•	1Password agent socket.
	•	~/.config/zsh/.zsh_sessions/ and .zcompdump*.
	•	App Store cache or app data.

.gitignore already includes:

zsh/.config/zsh/.zsh_sessions/
zsh/.config/zsh/.zcompdump*
**/.DS_Store
ssh/*.key
ssh/*.pem
ssh/*.pub
ssh/.ssh_repo_backup/
alfred/Alfred.alfredpreferences/
brew/Brewfile.*


⸻

Troubleshooting

Stow conflicts

stow -nv zsh | sed -n '1,120p'
# move or --adopt the listed targets, then:
stow -R --adopt zsh starship


MAS not installing
	•	Sign into App Store once.
	•	Then brew bundle --file ~/.dotfiles/brew/20-apps.Brewfile.

⸻

Philosophy

One shell (Homebrew zsh). One manager (Znap). One prompt (Starship). One repo (portable, reproducible).
