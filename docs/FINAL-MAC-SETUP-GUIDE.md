# Final Fresh-Mac Cleanup, Terminal, and Dotfiles Guide

This is the consolidated **start-to-finish** version of the work from this chat. It removes the dead ends and keeps the corrected paths, sequencing, commands, and final configuration.

The intended end state is:

- Existing Apple Account retained, but old iCloud/Safari state cleaned before rebuilding devices.
- Fresh Mac setup with Apple Silicon Homebrew.
- Homebrew Zsh as the login shell.
- Starship + Catppuccin Mocha powerline prompt.
- Sheldon with `fzf-tab`, autosuggestions, and syntax highlighting.
- `fzf`, zoxide, eza, bat, ripgrep, fd, dust, bottom, jq, Git, GitHub CLI, etc.
- Ghostty with MesloLGS Nerd Font.
- `mise` owns language runtimes.
- Dotfiles are the source of truth; live config files are symlinks into `~/.dotfiles`.
- A health-check script verifies the setup.
- macOS defaults are applied from a corrected script.
- Safari local-data wiping is handled separately and deliberately.

---

# 1. Clean the Apple/iCloud State Before Rebuilding the Mac

## Fresh iPhone baseline

Set up the fresh iPhone **without transferring another device**. Configure only local basics such as Wi-Fi, passcode, and Face ID, and remain signed out of the Apple Account initially.

The point is to establish a known-clean local device before allowing cloud data to arrive.

## Use the existing Mac as the temporary cloud-cleanup device

Keep the Mac signed into the existing Apple Account while removing old cloud state you do not want. Focus especially on:

- Safari data
- old iCloud backups
- iCloud Drive / app cloud data you no longer want
- Passwords / Keychain cloud data you intentionally want removed
- any other iCloud app data you do not want repopulating onto the fresh devices

Verify deletions and clear relevant **Recently Deleted** areas before considering the cloud state clean.

Turning syncing off does **not** itself delete cloud data. Delete first, verify, then use sync toggles to control what can repopulate.

## Clean handoff order

```text
fresh iPhone local setup, still signed out
        ↓
temporary Mac performs cloud cleanup
        ↓
verify deletions / Recently Deleted
        ↓
Mac syncing for cleaned services off
        ↓
sign fresh iPhone into Apple Account
        ↓
enable only services you have verified
        ↓
confirm trusted-device/account access
        ↓
erase/rebuild the Mac as new
        ↓
iPad next
        ↓
Apple Watch last
```

---

# 2. One-Time Safari Local Wipe

The **verified** cleaner from this chat was `safari-wipe-v2.py`. It successfully reached:

```text
Eligible: 0 files; logical 0 B; allocated estimate 0 B.
```

The corrected behavior was:

- dry-run by default
- one `lsof` snapshot instead of one `lsof` process per file
- optional termination of current-user Safari/Passwords processes
- no `sudo` process killing
- SQLite `.db`, `-wal`, `-shm`, `-journal`, and related files handled as families
- if a live SQLite family is open, that family is skipped instead of risking corruption
- files revalidated immediately before deletion
- visible progress during deletion
- bookmarks, passwords, Keychain, passkeys, extensions, and credential-like paths protected
- no claim that local deletion erases remote/iCloud Safari data

## Preview

```bash
python3 safari-wipe-v2.py --scope full --quiet
```

## Aggressive local wipe

```bash
python3 safari-wipe-v2.py \
  --scope full \
  --apply \
  --kill-safari \
  --force-kill \
  --yes
```

## Verify

```bash
python3 safari-wipe-v2.py --scope full --quiet
```

Ideal:

```text
Eligible: 0 files; logical 0 B; allocated estimate 0 B.
```

If macOS recreates a handful of Safari database files during the first pass, run the aggressive command once more and verify again.

A Bash port was requested later for temporary fresh-Mac use. The Python v2 flow above is the one that was actually exercised to a clean zero in this chat. If you use the Bash port, preserve the same behavior and flags.

Do **not** replace this with a blind `rm -rf ~/Library/Safari` or wholesale Safari-container deletion.

---

# 3. Rebuild the Mac

Once the cloud state is where you want it and the fresh iPhone is signed in successfully, erase/rebuild the Mac as new.

Do not migrate the old Mac user profile if the goal is a truly fresh configuration.

---

# 4. Install Apple Command Line Tools

```bash
xcode-select --install
```

Verify:

```bash
xcode-select -p
```

Expected:

```text
/Library/Developer/CommandLineTools
```

Check architecture:

```bash
uname -m
```

Apple Silicon should return:

```text
arm64
```

---

# 5. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Initialize it for the current shell:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Verify:

```bash
brew --version
brew doctor
```

You want:

```text
Your system is ready to brew.
```

---

# 6. Restore the Dotfiles Repository

Restore the repo **before** creating live symlinks.

```bash
git clone <your-dotfiles-repository-url> ~/.dotfiles
cd ~/.dotfiles
git status
find . -maxdepth 2 -type f | sort
```

The important layout is:

```text
~/.dotfiles/
├── Brewfile
├── README.md
├── check-setup.sh
├── docs/
├── ghostty/
│   └── config.ghostty
├── mise/
│   └── config.toml
├── sheldon/
│   └── plugins.toml
├── starship/
│   └── starship.toml
└── zsh/
    ├── .zprofile
    └── .zshrc
```

A macOS defaults script is best kept at:

```text
~/.dotfiles/macos/defaults.sh
```

---

# 7. Install the Homebrew Software

Preferred method:

```bash
brew update
brew bundle --file="$HOME/.dotfiles/Brewfile"
```

Final policy:

- Homebrew owns system tools, terminal tools, apps, services, and utilities.
- `mise` owns language runtimes such as Node and Python.
- Avoid duplicate Node/Python/Bun/PHP installs in Homebrew when `mise` owns them.
- No separate Homebrew curl is needed merely for this shell setup.

Core terminal/tooling set:

```text
bash zsh sheldon starship fzf zoxide direnv tmux
bottom dust eza bat fd ripgrep tree watch yazi
coreutils gnu-sed grep wget jq yq
awscli cloudflared gnupg pinentry-mac
git gh git-delta git-extras git-filter-repo lazygit
mise uv
postgresql@17 redis mkcert stripe-cli stripe-mock
ffmpeg webp imagemagick folderify gifsicle jpegoptim
oxipng pngpaste pngquant spaceman-diff yt-dlp mas
```

## Important multiline-command correction

Do **not** do this:

```bash
brew install
starship
sheldon
fzf
```

That runs `brew install` with no package arguments, then tries to execute the package names as commands.

If installing manually, use backslashes:

```bash
brew install \
  starship \
  sheldon \
  fzf \
  eza \
  zoxide \
  bat \
  ripgrep \
  fd \
  dust \
  bottom \
  jq \
  tree \
  wget \
  git \
  gh
```

---

# 8. Make Homebrew Zsh the Login Shell

```bash
brew install zsh
```

Register it:

```bash
grep -qxF '/opt/homebrew/bin/zsh' /etc/shells || \
  echo '/opt/homebrew/bin/zsh' | sudo tee -a /etc/shells
```

Set it:

```bash
chsh -s /opt/homebrew/bin/zsh
```

Close/reopen the terminal, then verify:

```bash
echo "$SHELL"
```

Expected:

```text
/opt/homebrew/bin/zsh
```

---

# 9. Canonical Zsh Configuration

## `~/.dotfiles/zsh/.zprofile`

```zsh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

## `~/.dotfiles/zsh/.zshrc`

```zsh
# ── Environment ──────────────────────────────────────────────

[[ -o interactive ]] || return

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export PATH="$HOME/.local/bin:$PATH"

export EDITOR="nano"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R"

# ── History ──────────────────────────────────────────────────

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# ── Shell ────────────────────────────────────────────────────

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS

# ── Completion ───────────────────────────────────────────────

autoload -Uz compinit
compinit

zstyle ':completion:*' menu no
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|=*' \
  'l:|=* r:|=*'

# ── fzf ──────────────────────────────────────────────────────

export FZF_DEFAULT_OPTS="
  --height=70%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='❯ '
  --pointer='▶'
  --marker='✓'
"

export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null'
  --preview-window=right:60%:wrap
"

export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --icons=always --color=always {} 2>/dev/null'
  --preview-window=right:60%
"

source <(fzf --zsh)

# ── zoxide ───────────────────────────────────────────────────

eval "$(zoxide init zsh)"

# ── mise ─────────────────────────────────────────────────────

eval "$(mise activate zsh)"

# ── Aliases ──────────────────────────────────────────────────

alias ls='eza --icons=auto'
alias ll='eza -lah --icons=auto --group-directories-first'
alias la='eza -a --icons=auto --group-directories-first'
alias lt='eza --tree --level=2 --icons=auto'

alias cat='bat --paging=never'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

alias c='clear'
alias reload='exec zsh'

# ── Sheldon ──────────────────────────────────────────────────

eval "$(sheldon source)"

# ── fzf-tab ──────────────────────────────────────────────────

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':fzf-tab:complete:cd:*' \
  fzf-preview 'eza --tree --level=2 --icons=always --color=always "$realpath" 2>/dev/null'

zstyle ':fzf-tab:complete:*:*' \
  fzf-preview 'if [[ -d $realpath ]]; then
    eza --tree --level=2 --icons=always --color=always "$realpath" 2>/dev/null
  elif [[ -f $realpath ]]; then
    bat --color=always --style=numbers --line-range=:300 "$realpath" 2>/dev/null
  fi'

zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':completion:*:git-checkout:*' sort false

# ── Starship ─────────────────────────────────────────────────

eval "$(starship init zsh)"
```

---

# 10. Sheldon

## `~/.dotfiles/sheldon/plugins.toml`

```toml
shell = "zsh"

[plugins.fzf-tab]
github = "Aloxaf/fzf-tab"

[plugins.zsh-autosuggestions]
github = "zsh-users/zsh-autosuggestions"
use = ["zsh-autosuggestions.zsh"]

[plugins.zsh-syntax-highlighting]
github = "zsh-users/zsh-syntax-highlighting"
use = ["zsh-syntax-highlighting.zsh"]
```

After plugin changes:

```bash
sheldon lock
exec zsh
```

---

# 11. Starship

## `~/.dotfiles/starship/starship.toml`

```toml
"$schema" = "https://starship.rs/config-schema.json"

add_newline = true
scan_timeout = 30
command_timeout = 800

palette = "catppuccin_mocha"

format = """
[](lavender)\
$os\
$username\
[](fg:lavender bg:blue)\
$directory\
[](fg:blue bg:green)\
$git_branch\
$git_status\
[](fg:green bg:peach)\
$nodejs\
$python\
$rust\
$golang\
$java\
$swift\
$package\
[](fg:peach bg:surface0)\
$cmd_duration\
[](fg:surface0)\
$fill\
$battery\
$time\
$line_break\
$character
"""

[palettes.catppuccin_mocha]
rosewater = "#f5e0dc"
flamingo = "#f2cdcd"
pink = "#f5c2e7"
mauve = "#cba6f7"
red = "#f38ba8"
maroon = "#eba0ac"
peach = "#fab387"
yellow = "#f9e2af"
green = "#a6e3a1"
teal = "#94e2d5"
sky = "#89dceb"
sapphire = "#74c7ec"
blue = "#89b4fa"
lavender = "#b4befe"
text = "#cdd6f4"
subtext1 = "#bac2de"
subtext0 = "#a6adc8"
overlay2 = "#9399b2"
overlay1 = "#7f849c"
overlay0 = "#6c7086"
surface2 = "#585b70"
surface1 = "#45475a"
surface0 = "#313244"
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"

[os]
disabled = false
style = "fg:crust bg:lavender"
format = "[$symbol]($style)"

[os.symbols]
Macos = "  "

[username]
show_always = false
style_user = "fg:crust bg:lavender"
format = "[$user ]($style)"

[directory]
style = "fg:crust bg:blue"
format = "[ $path ]($style)"
truncation_length = 4
truncate_to_repo = false
home_symbol = "~"
read_only = " 󰌾"

[directory.substitutions]
"Documents" = "󰈙 Documents"
"Downloads" = " Downloads"
"Desktop" = " Desktop"
"Projects" = "󰲋 Projects"
"Developer" = "󰲋 Developer"

[git_branch]
symbol = ""
style = "fg:crust bg:green"
format = "[ $symbol $branch ]($style)"

[git_status]
style = "fg:crust bg:green"
format = "[$all_status$ahead_behind ]($style)"
conflicted = "=${count} "
ahead = "⇡${count} "
behind = "⇣${count} "
diverged = "⇕${ahead_count}⇣${behind_count} "
untracked = "?${count} "
stashed = "󰏗 ${count} "
modified = "!${count} "
staged = "+${count} "
renamed = "»${count} "
deleted = "✘${count} "

[nodejs]
symbol = ""
style = "fg:crust bg:peach"
format = "[ $symbol $version ]($style)"

[python]
symbol = ""
style = "fg:crust bg:peach"
format = "[ $symbol $version( \\($virtualenv\\)) ]($style)"

[rust]
symbol = ""
style = "fg:crust bg:peach"
format = "[ $symbol $version ]($style)"

[golang]
symbol = ""
style = "fg:crust bg:peach"
format = "[ $symbol $version ]($style)"

[java]
symbol = ""
style = "fg:crust bg:peach"
format = "[ $symbol $version ]($style)"

[swift]
symbol = ""
style = "fg:crust bg:peach"
format = "[ $symbol $version ]($style)"

[package]
symbol = "󰏗"
style = "fg:crust bg:peach"
format = "[ $symbol $version ]($style)"

[cmd_duration]
min_time = 2000
style = "fg:text bg:surface0"
format = "[ 󱎫 $duration ]($style)"

[fill]
symbol = " "

[battery]
full_symbol = "󰁹"
charging_symbol = "󰂄"
discharging_symbol = "󰂃"
format = "[$symbol $percentage]($style) "

[[battery.display]]
threshold = 20
style = "bold red"

[[battery.display]]
threshold = 50
style = "bold yellow"

[[battery.display]]
threshold = 100
style = "dimmed green"

[time]
disabled = false
time_format = "%I:%M %p"
style = "dimmed white"
format = "[ $time]($style)"

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
vimcmd_symbol = "[❮](bold mauve)"
```

---

# 12. Ghostty

Correct live filename:

```text
~/.config/ghostty/config.ghostty
```

Not:

```text
~/.config/ghostty/config
```

## `~/.dotfiles/ghostty/config.ghostty`

```ini
font-family = MesloLGS Nerd Font
font-size = 14

theme = Catppuccin Mocha

window-padding-x = 10
window-padding-y = 8
window-padding-balance = true

macos-titlebar-style = transparent

background-opacity = 0.96
background-blur = 20

window-inherit-font-size = true
window-inherit-working-directory = true
tab-inherit-working-directory = true
split-inherit-working-directory = true

scrollback-limit = 100000
```

Fully quit/reopen Ghostty after major appearance changes.

---

# 13. mise

`mise`, not Homebrew, owns language runtimes.

The earlier repo pin was Node LTS + Python 3.14, while the later shell in this chat showed Python 3.15.0. Keep the repo's intentional current pin rather than downgrading simply to match an older note.

Example current config:

## `~/.dotfiles/mise/config.toml`

```toml
[tools]
node = "lts"
python = "3.15"
```

Install configured runtimes:

```bash
mise install
mise current
```

---

# 14. Create the Live Symlinks Safely

This is where the biggest earlier breakage happened.

**Rule: verify every dotfiles source exists before creating the live symlink.** A symlink can exist while its target is missing.

Create config directories:

```bash
mkdir -p \
  ~/.config/sheldon \
  ~/.config/ghostty \
  ~/.config/mise
```

Verify sources first:

```bash
for f in \
  ~/.dotfiles/zsh/.zshrc \
  ~/.dotfiles/zsh/.zprofile \
  ~/.dotfiles/starship/starship.toml \
  ~/.dotfiles/sheldon/plugins.toml \
  ~/.dotfiles/ghostty/config.ghostty \
  ~/.dotfiles/mise/config.toml
do
  [[ -e "$f" ]] && echo "SOURCE OK  $f" || echo "MISSING    $f"
done
```

Do not continue until all six show `SOURCE OK`.

Back up live regular files if present:

```bash
[ -e ~/.zshrc ] && [ ! -L ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup
[ -e ~/.zprofile ] && [ ! -L ~/.zprofile ] && mv ~/.zprofile ~/.zprofile.backup

[ -e ~/.config/starship.toml ] && [ ! -L ~/.config/starship.toml ] && \
  mv ~/.config/starship.toml ~/.config/starship.toml.backup

[ -e ~/.config/sheldon/plugins.toml ] && [ ! -L ~/.config/sheldon/plugins.toml ] && \
  mv ~/.config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml.backup

[ -e ~/.config/ghostty/config.ghostty ] && [ ! -L ~/.config/ghostty/config.ghostty ] && \
  mv ~/.config/ghostty/config.ghostty ~/.config/ghostty/config.ghostty.backup

[ -e ~/.config/mise/config.toml ] && [ ! -L ~/.config/mise/config.toml ] && \
  mv ~/.config/mise/config.toml ~/.config/mise/config.toml.backup
```

Create links:

```bash
ln -sfn ~/.dotfiles/zsh/.zprofile ~/.zprofile
ln -sfn ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sfn ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
ln -sfn ~/.dotfiles/sheldon/plugins.toml ~/.config/sheldon/plugins.toml
ln -sfn ~/.dotfiles/ghostty/config.ghostty ~/.config/ghostty/config.ghostty
ln -sfn ~/.dotfiles/mise/config.toml ~/.config/mise/config.toml
```

Verify both link existence and target health:

```bash
for f in \
  ~/.zshrc \
  ~/.zprofile \
  ~/.config/starship.toml \
  ~/.config/sheldon/plugins.toml \
  ~/.config/ghostty/config.ghostty \
  ~/.config/mise/config.toml
do
  if [[ -L "$f" && -e "$f" ]]; then
    echo "OK      $f -> $(readlink "$f")"
  else
    echo "PROBLEM $f"
  fi
done
```

You want six `OK` lines.

Then:

```bash
touch ~/.hushlogin
sheldon lock
mise install
exec zsh
```

---

# 15. Corrected macOS Defaults Script

The earlier broken script produced `status: command not found` because its helper function and option initialization were missing.

Save this as:

```text
~/.dotfiles/macos/defaults.sh
```

```bash
#!/usr/bin/env bash

set -Eeuo pipefail

UNSAFE=false
UPDATE=false

status() {
  printf '\n==> %s\n' "$1"
}

usage() {
  cat <<'USAGE'
Usage: defaults.sh [options]

Options:
  --update    Run Homebrew + Mac App Store maintenance.
  --unsafe    Also apply security-reducing settings.
  -h, --help  Show help.
USAGE
}

while (($#)); do
  case "$1" in
    --update) UPDATE=true ;;
    --unsafe) UNSAFE=true ;;
    -h|--help) usage; exit 0 ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This script is intended for macOS only.\n' >&2
  exit 1
fi

status "Applying keyboard and text preferences"

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false

status "Applying window tabbing preference"

defaults write -g AppleWindowTabbingMode -string "always"

status "Applying Dock preferences"

defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock show-process-indicators -bool false
defaults write com.apple.dock persistent-apps -array

status "Showing hidden files and suppressing the login banner"

defaults write com.apple.finder AppleShowAllFiles -bool true
touch "$HOME/.hushlogin"

if [[ "$UNSAFE" == true ]]; then
  status "Applying --unsafe settings"
  printf 'WARNING: These settings reduce normal macOS security protections.\n'

  defaults write com.apple.LaunchServices LSQuarantine -bool false
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
  defaults write com.apple.CrashReporter DialogType -string "none"

  if command -v spctl >/dev/null 2>&1; then
    status "Requesting Gatekeeper disable"
    printf 'macOS may require additional confirmation in System Settings.\n'
    sudo spctl --master-disable || true
  fi
fi

if [[ "$UPDATE" == true ]]; then
  status "Running software maintenance"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  if command -v brew >/dev/null 2>&1; then
    brew update
    brew upgrade --greedy
    brew cleanup --prune=all
  else
    status "Homebrew not installed; skipping Homebrew maintenance"
  fi

  if command -v mas >/dev/null 2>&1; then
    mas upgrade
  else
    status "mas not installed; skipping Mac App Store upgrades"
  fi
fi

status "Restarting Dock and Finder"

for service in Dock Finder; do
  if /usr/bin/pgrep -x "$service" >/dev/null 2>&1; then
    /usr/bin/killall "$service" >/dev/null 2>&1 || true
  fi
done

status "Done"
printf 'Some preferences may require reopening apps or logging out/in.\n'
```

Make executable:

```bash
chmod +x ~/.dotfiles/macos/defaults.sh
```

Normal run:

```bash
~/.dotfiles/macos/defaults.sh
```

With maintenance:

```bash
~/.dotfiles/macos/defaults.sh --update
```

`--unsafe` intentionally weakens macOS protections and is **not** part of the normal recommended run:

```bash
~/.dotfiles/macos/defaults.sh --unsafe
```

---

# 16. Final Health Check

Your final health-check script should validate:

- Homebrew Zsh login shell
- `ZDOTDIR`
- all six live symlinks
- all six source files
- core command availability
- Sheldon / Starship / zoxide / mise initialization
- Sheldon plugin config load
- Git repository and upstream state
- `.hushlogin`

Run it with:

```bash
~/.dotfiles/check-setup.sh
```

The healthy result from this chat was:

```text
Warnings: 0
Failed:   0
Terminal configuration looks healthy.
```

The critical symlink check inside that script is:

```bash
if [[ -L "$link" && -e "$link" ]]; then
  echo "OK"
else
  echo "BROKEN"
fi
```

That distinction matters: `ls -l` can show a symlink even when the target is missing.

---

# 17. Final Git Commit

When the health check is clean:

```bash
cd ~/.dotfiles
git status
git add .
git commit -m "Finalize fresh Mac setup"
git push
```

Then:

```bash
git status
```

You want the working tree clean and the branch synchronized with upstream.

---

# 18. Functional Tests

Reload:

```bash
exec zsh
```

Check the shell:

```bash
echo "shell works"
```

Check binaries:

```bash
command -v brew zsh starship sheldon fzf zoxide eza bat fd rg mise git gh
```

Test aliases:

```bash
ll
lt
```

Test zoxide:

```bash
mkdir -p ~/Desktop/zoxide-test
cd ~/Desktop/zoxide-test
cd ~
z zoxide
```

Clean up:

```bash
rm -rf ~/Desktop/zoxide-test
```

Test fzf:

```text
Ctrl-R   fuzzy history
Ctrl-T   fuzzy file search
Alt-C    fuzzy directory navigation
```

Test fzf-tab:

```text
type: cd ~/
press: Tab
```

Test Starship duration:

```bash
sleep 3
```

The next prompt should show approximately:

```text
󱎫 3s
```

Test mise:

```bash
mise current
node --version
python3 --version
```

---

# 19. Troubleshooting Lessons From This Setup

## Stock Zsh prompt suddenly returns

If Starship disappears and you get a plain prompt, inspect:

```bash
echo "SHELL=$SHELL"
echo "ZDOTDIR=${ZDOTDIR:-<unset>}"
ls -l ~/.zshrc ~/.zprofile
readlink ~/.zshrc
readlink ~/.zprofile
```

The actual failure we found was that `.zshrc` and `.zprofile` had become tiny regular files instead of symlinks.

Correct state:

```text
~/.zshrc    -> ~/.dotfiles/zsh/.zshrc
~/.zprofile -> ~/.dotfiles/zsh/.zprofile
```

## Do not rely on `ls -l` alone

Use:

```bash
[[ -L ~/.zshrc && -e ~/.zshrc ]] && echo OK || echo BROKEN
```

## Ghostty path

Correct:

```text
~/.config/ghostty/config.ghostty
```

Wrong:

```text
~/.config/ghostty/config
```

## `Last login` reappears

```bash
touch ~/.hushlogin
```

## Sheldon binary exists but plugins seem absent

Check the whole `.zshrc`:

```bash
grep -nE 'sheldon|starship|zoxide|mise' ~/.zshrc
```

## `status: command not found` in `defaults.sh`

Use the corrected script above; the broken copy lacked `status()` and option initialization.

## Safari wipe appears frozen after `DELETE`

The first implementation ran `lsof` once per candidate. The corrected v2 implementation uses one snapshot and progress output.

---

# 20. Routine Maintenance

Ordinary update:

```bash
brew update
brew upgrade
mas upgrade
```

Aggressive Homebrew pass:

```bash
brew update
brew upgrade --greedy
brew cleanup --prune=all
mas upgrade
```

`--prune=all` is aggressive cache cleanup; it does not need to be a daily routine.

After Sheldon plugin changes:

```bash
sheldon lock
exec zsh
```

After mise changes:

```bash
mise install
mise current
```

After dotfile changes:

```bash
~/.dotfiles/check-setup.sh

cd ~/.dotfiles
git status
git add .
git commit -m "Update dotfiles"
git push
```

---

# Final End State

The six live configuration links should resolve to:

```text
~/.zshrc
  -> ~/.dotfiles/zsh/.zshrc

~/.zprofile
  -> ~/.dotfiles/zsh/.zprofile

~/.config/starship.toml
  -> ~/.dotfiles/starship/starship.toml

~/.config/sheldon/plugins.toml
  -> ~/.dotfiles/sheldon/plugins.toml

~/.config/ghostty/config.ghostty
  -> ~/.dotfiles/ghostty/config.ghostty

~/.config/mise/config.toml
  -> ~/.dotfiles/mise/config.toml
```

And the stack is:

```text
Ghostty / Terminal.app
        │
        └── Homebrew Zsh
            │
            ├── Starship
            │   └── Catppuccin Mocha powerline prompt
            │
            ├── Sheldon
            │   ├── fzf-tab
            │   ├── zsh-autosuggestions
            │   └── zsh-syntax-highlighting
            │
            ├── fzf
            ├── zoxide
            ├── mise
            │   └── language runtimes
            └── modern CLI tools
```

Final verification:

```bash
~/.dotfiles/check-setup.sh
```

If it returns zero failures, the shell/dotfiles portion of the rebuild is complete.
