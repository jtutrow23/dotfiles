# Terminal Setup

This is the current terminal stack:

```text
Ghostty
└── Homebrew Zsh
    ├── Starship
    ├── Sheldon
    │   ├── fzf-tab
    │   ├── zsh-autosuggestions
    │   └── zsh-syntax-highlighting
    ├── fzf
    ├── zoxide
    ├── mise
    │   ├── Node LTS
    │   └── Python 3.14
    └── modern CLI tools
```

## 1. Apple Command Line Tools

```bash
xcode-select --install
xcode-select -p
uname -m
```

Expected on Apple Silicon:

```text
/Library/Developer/CommandLineTools
arm64
```

## 2. Homebrew

Install Homebrew from the official installer, then ensure `~/.zprofile` contains:

```zsh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

Verify:

```bash
brew --version
brew doctor
```

## 3. Install packages

From the dotfiles directory:

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

## 4. Use Homebrew Zsh

```bash
grep -qxF '/opt/homebrew/bin/zsh' /etc/shells || \
  echo '/opt/homebrew/bin/zsh' | sudo tee -a /etc/shells

chsh -s /opt/homebrew/bin/zsh
```

Restart the terminal and verify:

```bash
echo $SHELL
```

Expected:

```text
/opt/homebrew/bin/zsh
```

## 5. Link configuration

Create config directories:

```bash
mkdir -p ~/.config/sheldon ~/.config/ghostty ~/.config/mise
```

Link the tracked files:

```bash
ln -sf ~/.dotfiles/zsh/.zprofile ~/.zprofile
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
ln -sf ~/.dotfiles/sheldon/plugins.toml ~/.config/sheldon/plugins.toml
ln -sf ~/.dotfiles/ghostty/config.ghostty ~/.config/ghostty/config.ghostty
ln -sf ~/.dotfiles/mise/config.toml ~/.config/mise/config.toml
```

Reload:

```bash
exec zsh
```

On the first run, Sheldon may clone its plugins and create its lockfile.

## 6. Ghostty

Open Ghostty from Applications.

Check the exact installed font name if needed:

```bash
ghostty +list-fonts | grep -i meslo
```

Check the theme name:

```bash
ghostty +list-themes | grep -i catppuccin
```

The tracked config uses:

```text
MesloLGS Nerd Font
Catppuccin Mocha
```

Quit and reopen Ghostty after the first configuration.

## 7. mise runtimes

The tracked global config selects:

```text
Node:   LTS
Python: 3.14
```

Install/activate them:

```bash
mise install
mise current
```

Verify:

```bash
node --version
npm --version
python --version
pip --version
```

For a project-specific version:

```bash
cd ~/Projects/example
mise use node@22
mise use python@3.12
```

## 8. Shell checks

```bash
starship --version
sheldon --version
fzf --version
eza --version
zoxide --version
mise --version
```

Test aliases:

```bash
ll
lt
```

Test fuzzy history:

```text
Ctrl-R
```

Test fuzzy file picker:

```text
Ctrl-T
```

Test directory picker:

```text
Option-C / Alt-C
```

Test `fzf-tab`:

```text
cd ~/
```

Press **Tab**.

Test zoxide:

```bash
mkdir -p ~/Desktop/zoxide-test
cd ~/Desktop/zoxide-test
cd ~
z zoxide
```

Then remove the test directory:

```bash
rm -rf ~/Desktop/zoxide-test
```

Test Starship command duration:

```bash
sleep 3
```

The next prompt should display the command duration.

## 9. macOS finishing touches

See:

```text
docs/macos-preferences.md
```

That covers permanent Finder hidden-file visibility and hiding the "Last login" banner.
