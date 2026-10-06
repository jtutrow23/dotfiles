# Terminal Setup

This guide rebuilds and applies the tracked terminal configuration on an Apple Silicon Mac.

The setup intentionally separates responsibilities:

```text
Ghostty                  terminal emulator
Homebrew Zsh             interactive shell
Starship                 prompt
Sheldon                  Zsh plugin manager
fzf + fzf-tab            fuzzy search and completion
zoxide                   smart directory navigation
mise                     language runtime manager
Homebrew                 CLI tools, apps, and local services
```

The tracked stack is:

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

---

## Defaults

These are the defaults established by the tracked configuration.

### Shell

```text
Shell:        /opt/homebrew/bin/zsh
Editor:       nano
Visual:       nano
Pager:        less
LESS:         -R
User PATH:    ~/.local/bin
```

XDG paths:

```text
Config:       ~/.config
Cache:        ~/.cache
Data:         ~/.local/share
```

### History

```text
History file: ~/.zsh_history
History size: 100000
Saved lines:  100000
```

Enabled behavior includes:

- shared history between interactive shells
- duplicate cleanup
- commands beginning with a space excluded from history
- reduced unnecessary whitespace
- timestamps through extended history

### Shell behavior

```text
AUTO_CD               enabled
INTERACTIVE_COMMENTS  enabled
```

`AUTO_CD` allows entering a directory by typing its path without explicitly typing `cd`.

### Completion

Zsh completion is enabled through `compinit`.

Completion defaults include:

- `fzf-tab` instead of the traditional Zsh selection menu
- grouped completion results
- completion descriptions
- forgiving case matching

### fzf

Global interface:

```text
Height:       70%
Layout:       reverse
Border:       rounded
Prompt:       ❯
Pointer:      ▶
Marker:       ✓
```

Key workflows:

```text
Ctrl-R        fuzzy command history
Ctrl-T        fuzzy file picker
Option-C      fuzzy directory picker
Tab           fzf-tab completion
```

`Ctrl-T` searches files with `fd`, including hidden files, while excluding `.git`, and previews files with `bat`.

`Option-C` searches directories with `fd` and previews them with an `eza` tree.

### zoxide

`zoxide` replaces repetitive directory traversal with learned navigation.

Examples:

```bash
z project
z downloads
```

### mise

Global tracked runtimes:

```text
Node:         LTS
Python:       3.14
```

Homebrew does not own Node or Python in this setup. `mise` does.

### Aliases

Directory listings:

```text
ls       eza with icons
ll       detailed listing, hidden files, directories first
la       all files, directories first
lt       two-level tree
```

File viewing:

```text
cat      bat without paging
```

Navigation:

```text
..       cd ..
...      cd ../..
....     cd ../../..
```

Git:

```text
gs       git status
gl       compact graph log
gd       git diff
ga       git add
gc       git commit
gp       git push
```

Shell:

```text
c        clear
reload   exec zsh
```

### Sheldon plugins

Tracked plugins:

```text
fzf-tab
zsh-autosuggestions
zsh-syntax-highlighting
```

### Starship

The tracked prompt uses:

```text
Palette:      Catppuccin Mocha
Layout:       two-line Powerline
Directory:    visible
Git:          branch + status
Runtimes:     contextual
Duration:     shown for commands >= 2 seconds
Battery:      visible
Time:         12-hour clock
```

Runtime modules only appear when relevant to the current directory/project.

### Ghostty

Tracked defaults:

```text
Font:                  MesloLGS Nerd Font
Font size:             14
Theme:                 Catppuccin Mocha
Horizontal padding:    10
Vertical padding:      8
Balanced padding:      enabled
Titlebar:              transparent
Background opacity:    0.96
Background blur:       20
Scrollback:            100000
```

New windows, tabs, and splits inherit the working directory.

---

# Fresh Mac Setup

## 1. Install Apple Command Line Tools

```bash
xcode-select --install
```

Verify:

```bash
xcode-select -p
uname -m
```

Expected on Apple Silicon:

```text
/Library/Developer/CommandLineTools
arm64
```

---

## 2. Install Homebrew

Install Homebrew using the current official installer from:

```text
https://brew.sh
```

After installation, ensure `~/.zprofile` contains:

```zsh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

For the dotfiles-managed version, this will later be linked from:

```text
~/.dotfiles/zsh/.zprofile
```

Verify:

```bash
brew --version
brew doctor
```

A healthy installation should report:

```text
Your system is ready to brew.
```

---

## 3. Put the dotfiles repository in place

The expected location is:

```text
~/.dotfiles
```

If restoring from Git, clone the repository there.

Then:

```bash
cd ~/.dotfiles
```

---

## 4. Install tracked software

Sign in to the Mac App Store first if you want the `mas` entries installed.

Then run:

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

Check the Brewfile at any time with:

```bash
brew bundle check --file=~/.dotfiles/Brewfile
```

Preview anything Homebrew considers extra:

```bash
brew bundle cleanup --file=~/.dotfiles/Brewfile
```

Do not add `--force` until the proposed removals have been reviewed.

---

## 5. Use Homebrew Zsh

Register Homebrew Zsh as an allowed login shell:

```bash
grep -qxF '/opt/homebrew/bin/zsh' /etc/shells || \
  echo '/opt/homebrew/bin/zsh' | sudo tee -a /etc/shells
```

Set it as the login shell:

```bash
chsh -s /opt/homebrew/bin/zsh
```

Close and reopen the terminal.

Verify:

```bash
echo $SHELL
```

Expected:

```text
/opt/homebrew/bin/zsh
```

---

## 6. Prepare configuration directories

```bash
mkdir -p \
  ~/.config/sheldon \
  ~/.config/ghostty \
  ~/.config/mise
```

Starship itself only needs `~/.config`, which already exists after the command above.

---

## 7. Back up existing configuration

Do this before creating links on a Mac that already has shell configuration.

```bash
[ -e ~/.zprofile ] && [ ! -L ~/.zprofile ] && mv ~/.zprofile ~/.zprofile.backup
[ -e ~/.zshrc ] && [ ! -L ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup

[ -e ~/.config/starship.toml ] && [ ! -L ~/.config/starship.toml ] && \
  mv ~/.config/starship.toml ~/.config/starship.toml.backup

[ -e ~/.config/sheldon/plugins.toml ] && [ ! -L ~/.config/sheldon/plugins.toml ] && \
  mv ~/.config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml.backup

[ -e ~/.config/ghostty/config.ghostty ] && [ ! -L ~/.config/ghostty/config.ghostty ] && \
  mv ~/.config/ghostty/config.ghostty ~/.config/ghostty/config.ghostty.backup

[ -e ~/.config/mise/config.toml ] && [ ! -L ~/.config/mise/config.toml ] && \
  mv ~/.config/mise/config.toml ~/.config/mise/config.toml.backup
```

These backups are intentionally not committed to the dotfiles repository.

---

## 8. Link the tracked configuration

```bash
ln -sfn ~/.dotfiles/zsh/.zprofile ~/.zprofile
ln -sfn ~/.dotfiles/zsh/.zshrc ~/.zshrc

ln -sfn ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
ln -sfn ~/.dotfiles/sheldon/plugins.toml ~/.config/sheldon/plugins.toml
ln -sfn ~/.dotfiles/ghostty/config.ghostty ~/.config/ghostty/config.ghostty
ln -sfn ~/.dotfiles/mise/config.toml ~/.config/mise/config.toml
```

Verify the links:

```bash
ls -l ~/.zprofile ~/.zshrc
ls -l ~/.config/starship.toml
ls -l ~/.config/sheldon/plugins.toml
ls -l ~/.config/ghostty/config.ghostty
ls -l ~/.config/mise/config.toml
```

The right side of each `->` should point into `~/.dotfiles`.

---

## 9. Apply Zsh and Sheldon

Start a fresh Zsh process:

```bash
exec zsh
```

On the first run, Sheldon may clone:

```text
fzf-tab
zsh-autosuggestions
zsh-syntax-highlighting
```

and create its lockfile.

If `plugins.toml` is changed later, apply the plugin changes with:

```bash
sheldon lock
exec zsh
```

---

## 10. Install the mise runtimes

The tracked file:

```text
~/.dotfiles/mise/config.toml
```

contains:

```toml
[tools]
node = "lts"
python = "3.14"
```

Install what it declares:

```bash
mise install
```

Verify:

```bash
mise current
node --version
npm --version
python --version
pip --version
```

For a project-specific override:

```bash
cd ~/Projects/example
mise use node@22
mise use python@3.12
```

The project configuration takes precedence while inside that project.

---

## 11. Open and verify Ghostty

Open Ghostty from Applications.

If needed, confirm the exact installed font:

```bash
ghostty +list-fonts | grep -i meslo
```

Confirm the available Catppuccin themes:

```bash
ghostty +list-themes | grep -i catppuccin
```

The tracked configuration expects:

```text
MesloLGS Nerd Font
Catppuccin Mocha
```

After first applying the configuration, fully quit and reopen Ghostty.

---

# Applying Future Changes

Because the live configuration files are symbolic links into `~/.dotfiles`, edits to either path modify the same tracked file.

For example:

```bash
nano ~/.zshrc
```

edits:

```text
~/.dotfiles/zsh/.zshrc
```

The same applies to Starship, Sheldon, Ghostty, and mise.

## `.zshrc` or `.zprofile`

Apply with:

```bash
exec zsh
```

Use this instead of repeatedly opening new terminal windows.

## Sheldon plugins

After changing:

```text
sheldon/plugins.toml
```

run:

```bash
sheldon lock
exec zsh
```

## Starship

Changes to:

```text
starship/starship.toml
```

are normally visible on the next prompt.

If something does not refresh as expected:

```bash
exec zsh
```

## Ghostty

Changes to:

```text
ghostty/config.ghostty
```

should be applied by reloading Ghostty's configuration or by quitting and reopening Ghostty.

For appearance-level changes such as opacity or blur, a full restart is the safest option.

## mise

After changing:

```text
mise/config.toml
```

install any newly declared versions:

```bash
mise install
```

Then verify:

```bash
mise current
```

The active environment is integrated into Zsh through:

```zsh
eval "$(mise activate zsh)"
```

## Brewfile

After adding software:

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

Check that everything is installed:

```bash
brew bundle check --file=~/.dotfiles/Brewfile
```

Preview packages that are no longer declared:

```bash
brew bundle cleanup --file=~/.dotfiles/Brewfile
```

## macOS preferences

See:

```text
docs/macos-preferences.md
```

Finder preference changes in that guide include `killall Finder`, so they take effect immediately after Finder restarts.

---

# Verification

## Shell

```bash
echo $SHELL
echo $EDITOR
echo $PAGER
```

Expected:

```text
/opt/homebrew/bin/zsh
nano
less
```

## Core tools

```bash
starship --version
sheldon --version
fzf --version
eza --version
bat --version
fd --version
rg --version
zoxide --version
mise --version
```

## Aliases

```bash
ls
ll
la
lt
```

`la` should include hidden files.

Check:

```bash
cat ~/.zshrc
```

It should render through `bat`.

## fzf

Use:

```text
Ctrl-R
```

for fuzzy command history.

Use:

```text
Ctrl-T
```

for fuzzy file selection with previews.

Use:

```text
Option-C / Alt-C
```

for fuzzy directory navigation.

## fzf-tab

Type:

```text
cd ~/
```

and press **Tab**.

Directory candidates should appear with previews.

## zoxide

```bash
mkdir -p ~/Desktop/zoxide-test
cd ~/Desktop/zoxide-test
cd ~
z zoxide
```

Expected destination:

```text
~/Desktop/zoxide-test
```

Clean up:

```bash
rm -rf ~/Desktop/zoxide-test
```

## Starship

Run:

```bash
sleep 3
```

The next prompt should show a command duration of approximately three seconds.

Inside a Git repository, the prompt should also expose Git branch/status information.

## Node and Python

```bash
node --version
npm --version
python --version
pip --version
```

The versions should be supplied by mise rather than Homebrew.

Check:

```bash
which node
which python
mise which node
mise which python
```

---

# macOS Finishing Touches

See:

```text
docs/macos-preferences.md
```

The tracked recommendations include:

- always showing hidden files in Finder
- hiding the macOS `Last login` banner

---

# Rollback

Because the setup backs up pre-existing files before linking them, rollback is straightforward.

Remove a link, for example:

```bash
rm ~/.zshrc
```

Restore the backup:

```bash
mv ~/.zshrc.backup ~/.zshrc
```

Then:

```bash
exec zsh
```

Use the equivalent `.backup` file for Starship, Sheldon, Ghostty, mise, or `.zprofile` if needed.

Only remove backup files after the linked dotfiles setup has been fully tested and committed.
