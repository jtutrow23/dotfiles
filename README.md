# dotfiles# dotfiles# 🧪 Justin’s macOS Dotfiles

Welcome to my personal dotfiles setup — optimized for:
- Apple Silicon Macs (M1/M2)
- `zsh` shell (with `znap` plugin manager)
- Homebrew-managed system installs
- Modular and minimal configuration

—

## 🚀 Setup (Step-by-Step)

### 1. Clone the repo
```sh
cd ~
git clone https://github.com/jtutrow23/dotfiles.git
```

### 2. Review or Customize
Make edits to:
- `zsh/.zshrc`
- `Brewfile`
- Optional: Add `zsh/aliases.sh`, `zsh/functions.sh`, `macos/defaults.sh`, etc.

### 3. Run the Bootstrap Script
```sh
cd ~/dotfiles
chmod +x bootstrap_dotfiles.sh
./bootstrap_dotfiles.sh
```
This will:
- Backup your existing `.zshrc`
- Symlink `dotfiles/zsh/.zshrc` → `~/.zshrc`
- Install Homebrew (if missing)
- Run `brew bundle` using the included Brewfile
- Source Zsh with your full plugin setup

—

## 🧩 Plugin System (Znap)
Uses [zsh-snap](https://github.com/jtutrow23/zsh-snap) fork via:
```zsh
[[ -r ~/Repos/znap/znap.zsh ]] || \
  git clone —depth 1 https://github.com/jtutrow23/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh
```

Includes:
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `zsh-vi-mode`
- `fzf-tab`
- `zsh-autocomplete`
- `zsh-autopair`
- `pure` prompt

—

## 🧪 SSH / GitHub Setup (1Password)
Ensure `~/.ssh/config` includes:
```ssh
Host github.com
  User git
  HostName github.com
  IdentityAgent ~/.1password/agent.sock
  IdentitiesOnly yes
```

And export the SSH socket in your shell:
```sh
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
```

Then test:
```sh
ssh -T git@github.com
```

—

## 🔧 Optional Add-Ons
- Add shell utilities via `brew install`
- Configure `starship`, `mise`, `asdf`, etc. via `znap eval`
- Customize macOS defaults with `defaults write` commands

—

## 📦 Structure
```txt
dotfiles/
├── Brewfile                  # All Homebrew, Cask, MAS apps
├── bootstrap_dotfiles.sh     # One-step installer
├── zsh/
│   └── .zshrc                # Zsh config (loads plugins)
│   └── aliases.sh            # (optional)
│   └── functions.sh          # (optional)
└── macos/
    └── defaults.sh           # (optional)
```

—

## 🧼 Reset or Re-run
To reapply:
```sh
cd ~/dotfiles && ./bootstrap_dotfiles.sh
```
To update plugins:
```sh
znap pull
```

—

## 👤 Author
Justin Tutrow ([@jtutrow23](https://github.com/jtutrow23))

—

PRs and tweaks welcome.
