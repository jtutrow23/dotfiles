# Apple Silicon Zsh Environment Setup

This guide consolidates the previous advice and gives you a single, correct workflow for configuring an Apple Silicon macOS system with Homebrew, Zsh, Znap, Starship, and the supporting tools you want. Every step is idempotent, so you can rerun commands without breaking the setup.

---

## 0. Prerequisites

1. **Command Line Tools** – Install them once per machine:
   ```sh
   xcode-select --install
   ```
2. **Terminal** – Use the stock Terminal, iTerm2, or any emulator you prefer.
3. **Dotfiles directory** – This guide assumes your dotfiles live in `~/jtutrow23`.

---

## 1. Install & Configure Homebrew

Homebrew's native prefix on Apple Silicon is `/opt/homebrew`.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Add Homebrew to login shells **exactly once** (the installer prints these commands, but run them explicitly to be sure):

```sh
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Verify:

```sh
brew --version
brew doctor
```

`brew doctor` should report “Your system is ready to brew.” Fix anything it flags.

---

## 2. Install Core CLI Packages

Install the tools you selected (plus utilities your aliases/functions expect):

```sh
brew install git zsh starship zoxide fzf eza bat neovim ripgrep fd unzip p7zip unrar
```

*Feel free to extend this list later or manage it via a `Brewfile`.*

Run the optional fzf extras once:

```sh
/opt/homebrew/opt/fzf/install --key-bindings --completion --no-bash --no-fish
```

This generates `~/.fzf.zsh`, which you'll source from Zsh.

---

## 3. Make Homebrew Zsh Your Login Shell

```sh
if ! grep -Fxq "/opt/homebrew/bin/zsh" /etc/shells; then
  echo "/opt/homebrew/bin/zsh" | sudo tee -a /etc/shells
fi

chsh -s /opt/homebrew/bin/zsh
```

Close and reopen your terminal (or run `exec zsh -l`) for the change to take effect.

---

## 4. Adopt XDG Paths for Zsh

You want your Zsh configs under `~/.config/zsh` while keeping the repository in `~/jtutrow23`. Create the directory tree once:

```sh
mkdir -p ~/.config/zsh ~/jtutrow23
```

Create minimal loaders in `$HOME`:

```sh
cat > ~/.zshenv <<'EOF'
export ZDOTDIR="$HOME/.config/zsh"
EOF

cat > ~/.zshrc <<'EOF'
[[ -r "$ZDOTDIR/zshrc" ]] && source "$ZDOTDIR/zshrc"
EOF
```

*(If you track dotfiles via symlinks, commit these loader files in `~/jtutrow23` and symlink them back into `$HOME`.)*

---

## 5. Main Zsh Configuration (`~/.config/zsh`)

Create the following files inside `~/.config/zsh`. Keep them in your repo (e.g. `~/jtutrow23/zsh/…`) and symlink into place if desired.

### `zshrc`

```sh
cat > ~/.config/zsh/zshrc <<'EOF'
# Quietly initialize Homebrew when available
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Load (or install) Znap
if [[ -r "$HOME/jtutrow23/znap/znap.zsh" ]]; then
  source "$HOME/jtutrow23/znap/znap.zsh"
else
  command -v git >/dev/null 2>&1 \
    && git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/jtutrow23/znap" \
    && source "$HOME/jtutrow23/znap/znap.zsh"
fi

# Optional: disable auto-compile to avoid stale caches on macOS updates
zstyle ':znap:*' auto-compile no

# Load modular config chunks
for file in options.zsh exports.zsh aliases.zsh functions.zsh; do
  [[ -r "$ZDOTDIR/$file" ]] && source "$ZDOTDIR/$file"
fi

# Plugins (syntax highlighting last)
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source zsh-users/zsh-history-substring-search
znap source Aloxaf/fzf-tab
znap source zsh-users/zsh-syntax-highlighting

# fzf key bindings (installed via brew script)
[[ -r ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Modern tooling
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Precompile for faster startup (safe to rerun)
znap compile "$ZDOTDIR" ~/jtutrow23/znap/*.zsh ~/jtutrow23/znap/scripts/*.zsh
EOF
```

### `options.zsh`

```sh
cat > ~/.config/zsh/options.zsh <<'EOF'
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zhistory"

setopt hist_ignore_dups
setopt share_history
setopt inc_append_history
setopt interactive_comments
setopt auto_cd
setopt extended_glob
setopt no_beep
bindkey -v
KEYTIMEOUT=1
EOF
```

### `exports.zsh`

```sh
cat > ~/.config/zsh/exports.zsh <<'EOF'
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less -R"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
EOF
```

### `aliases.zsh`

```sh
cat > ~/.config/zsh/aliases.zsh <<'EOF'
# eza replaces ls
alias l='eza -l --icons --group'
alias ll='eza -lgh --icons --group'
alias la='eza -la --icons --group'
alias lt='eza -lT --icons --group --level=2'

# Quality of life
alias ..='cd ..'
alias ...='cd ../..'
alias please='sudo'
alias cat='bat'
alias v='nvim'
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate'
alias gc='git commit'
alias fz='fzf'
EOF
```

### `functions.zsh`

```sh
cat > ~/.config/zsh/functions.zsh <<'EOF'
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

extract() {
  local file="$1"
  [[ -f "$file" ]] || { print -r -- "'$file' is not a file"; return 1; }
  case "$file" in
    *.tar.bz2|*.tbz2) tar xjf "$file" ;;
    *.tar.gz|*.tgz)   tar xzf "$file" ;;
    *.tar.xz)         tar xJf "$file" ;;
    *.tar)            tar xf "$file" ;;
    *.zip)            unzip -q "$file" ;;
    *.7z)             7z x "$file" ;;
    *.rar)            unrar x "$file" ;;
    *)                print -r -- "'$file' has unknown format"; return 2 ;;
  esac
}

reload() { source "$ZDOTDIR/zshrc" && print -P "%F{green}🔁 Zsh reloaded%f"; }
EOF
```

---

## 6. Starship Prompt Configuration

Starship reads `~/.config/starship.toml` by default:

```sh
mkdir -p ~/.config

cat > ~/.config/starship.toml <<'EOF'
format = """
$os$username$hostname$directory$git_branch$git_status$nodejs$python$rust$golang
$time$cmd_duration
$character
"""

[os]
format = '[$symbol]($style) '
style = "bold blue"
disabled = false

[username]
style_user = "bold fg:green"
format = "[$user]($style)@"
show_always = true

[hostname]
format = "[$hostname]($style) "
style = "bold fg:yellow"

[directory]
style = "bold fg:cyan"
format = "[$path]($style)[$read_only]($read_only_style) "
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = "🌱 "
style = "bold fg:magenta"
format = "on [$symbol$branch]($style) "

[git_status]
style = "fg:bright-black"
format = '([$all_status$ahead_behind]($style))'

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
vimcmd_symbol = "[❮](bold blue)"

[nodejs]
symbol = " "
style = "fg:green"
format = "via [$symbol($version)]($style) "

[python]
symbol = " "
style = "fg:yellow"
format = "via [$symbol($version)]($style) "

[rust]
symbol = "🦀 "
style = "fg:bright-red"
format = "via [$symbol($version)]($style) "

[golang]
symbol = " "
style = "fg:cyan"
format = "via [$symbol($version)]($style) "

[cmd_duration]
format = "took [$duration](bold yellow) "

[time]
disabled = false
format = '🕒 [$time]($style) '
style = "fg:bright-black"
time_format = "%I:%M %p"
EOF
```

---

## 7. Optional One-Shot Bootstrap Script

Put the following in `~/jtutrow23/bootstrap.sh`, make it executable (`chmod +x bootstrap.sh`), and run it (`~/jtutrow23/bootstrap.sh`). The script safely repeats the manual steps above, so you can use it on fresh machines.

```sh
#!/usr/bin/env bash
set -euo pipefail

if [[ $(uname -m) != "arm64" ]]; then
  echo "This bootstrap is designed for Apple Silicon (arm64) Macs." >&2
  exit 1
fi

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

brew update
brew install git zsh starship zoxide fzf eza bat neovim ripgrep fd unzip p7zip unrar

if [[ ! -f ~/.fzf.zsh ]]; then
  yes | /opt/homebrew/opt/fzf/install --key-bindings --completion --no-bash --no-fish
fi

if ! grep -Fxq "/opt/homebrew/bin/zsh" /etc/shells; then
  echo "/opt/homebrew/bin/zsh" | sudo tee -a /etc/shells
fi
[[ "$SHELL" != "/opt/homebrew/bin/zsh" ]] && chsh -s /opt/homebrew/bin/zsh

mkdir -p ~/.config/zsh ~/jtutrow23

cat > ~/.zshenv <<'EOD'
export ZDOTDIR="$HOME/.config/zsh"
EOD

cat > ~/.zshrc <<'EOD'
[[ -r "$ZDOTDIR/zshrc" ]] && source "$ZDOTDIR/zshrc"
EOD

cat > ~/.config/zsh/zshrc <<'EOD'
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [[ -r "$HOME/jtutrow23/znap/znap.zsh" ]]; then
  source "$HOME/jtutrow23/znap/znap.zsh"
else
  command -v git >/dev/null 2>&1 \
    && git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/jtutrow23/znap" \
    && source "$HOME/jtutrow23/znap/znap.zsh"
fi
zstyle ':znap:*' auto-compile no
for file in options.zsh exports.zsh aliases.zsh functions.zsh; do
  [[ -r "$ZDOTDIR/$file" ]] && source "$ZDOTDIR/$file"
fi
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source zsh-users/zsh-history-substring-search
znap source Aloxaf/fzf-tab
znap source zsh-users/zsh-syntax-highlighting
[[ -r ~/.fzf.zsh ]] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
znap compile "$ZDOTDIR" ~/jtutrow23/znap/*.zsh ~/jtutrow23/znap/scripts/*.zsh
EOD

cat > ~/.config/zsh/options.zsh <<'EOD'
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zhistory"
setopt hist_ignore_dups share_history inc_append_history interactive_comments auto_cd extended_glob no_beep
bindkey -v
KEYTIMEOUT=1
EOD

cat > ~/.config/zsh/exports.zsh <<'EOD'
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less -R"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
EOD

cat > ~/.config/zsh/aliases.zsh <<'EOD'
alias l='eza -l --icons --group'
alias ll='eza -lgh --icons --group'
alias la='eza -la --icons --group'
alias lt='eza -lT --icons --group --level=2'
alias ..='cd ..'
alias ...='cd ../..'
alias please='sudo'
alias cat='bat'
alias v='nvim'
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate'
alias gc='git commit'
alias fz='fzf'
EOD

cat > ~/.config/zsh/functions.zsh <<'EOD'
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }
extract() {
  local file="$1"
  [[ -f "$file" ]] || { print -r -- "'$file' is not a file"; return 1; }
  case "$file" in
    *.tar.bz2|*.tbz2) tar xjf "$file" ;;
    *.tar.gz|*.tgz)   tar xzf "$file" ;;
    *.tar.xz)         tar xJf "$file" ;;
    *.tar)            tar xf "$file" ;;
    *.zip)            unzip -q "$file" ;;
    *.7z)             7z x "$file" ;;
    *.rar)            unrar x "$file" ;;
    *)                print -r -- "'$file' has unknown format"; return 2 ;;
  esac
}
reload() { source "$ZDOTDIR/zshrc" && print -P "%F{green}🔁 Zsh reloaded%f"; }
EOD

mkdir -p ~/.config
cat > ~/.config/starship.toml <<'EOD'
format = """
$os$username$hostname$directory$git_branch$git_status$nodejs$python$rust$golang
$time$cmd_duration
$character
"""
[os]
format = '[$symbol]($style) '
style = "bold blue"
disabled = false
[username]
style_user = "bold fg:green"
format = "[$user]($style)@"
show_always = true
[hostname]
format = "[$hostname]($style) "
style = "bold fg:yellow"
[directory]
style = "bold fg:cyan"
format = "[$path]($style)[$read_only]($read_only_style) "
truncation_length = 3
truncation_symbol = "…/"
[git_branch]
symbol = "🌱 "
style = "bold fg:magenta"
format = "on [$symbol$branch]($style) "
[git_status]
style = "fg:bright-black"
format = '([$all_status$ahead_behind]($style))'
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
vimcmd_symbol = "[❮](bold blue)"
[nodejs]
symbol = " "
style = "fg:green"
format = "via [$symbol($version)]($style) "
[python]
symbol = " "
style = "fg:yellow"
format = "via [$symbol($version)]($style) "
[rust]
symbol = "🦀 "
style = "fg:bright-red"
format = "via [$symbol($version)]($style) "
[golang]
symbol = " "
style = "fg:cyan"
format = "via [$symbol($version)]($style) "
[cmd_duration]
format = "took [$duration](bold yellow) "
[time]
disabled = false
format = '🕒 [$time]($style) '
style = "fg:bright-black"
time_format = "%I:%M %p"
EOD

echo "Bootstrap complete. Run 'exec zsh -l' to start using the new shell."
```

---

## 8. Post-Install Checks

After manual steps or the bootstrap script, open a fresh terminal (or run `exec zsh -l`) and verify:

```sh
which zsh           # → /opt/homebrew/bin/zsh
echo $SHELL         # → /opt/homebrew/bin/zsh
echo $ZDOTDIR       # → /Users/you/.config/zsh
znap status         # first run will clone plugins; rerun to see status
starship explain | head -n 5
```

Try the interactive features:

- `Ctrl+T`, `Ctrl+R`, and `Alt+C` for fzf key bindings.
- Start typing a previous command and watch `zsh-autosuggestions` offer it.
- Use `Tab` on partial filenames to invoke `fzf-tab` fuzzy completion.
- Run `zoxide add /some/path` and later `z some` to jump there.
- Use `ll` or `la` to confirm the `eza` aliases work.

For plugin maintenance:

```sh
znap pull          # update plugins
znap compile "$ZDOTDIR" ~/jtutrow23/znap/*.zsh ~/jtutrow23/znap/scripts/*.zsh
```

For package maintenance:

```sh
brew update
brew upgrade
```

---

## 9. Version-Control Tips

- Track all configuration files in `~/jtutrow23` and symlink them into `$HOME` (e.g. via a small install script or GNU Stow).
- Commit a `Brewfile` if you prefer `brew bundle` for reproducible package installs.
- Keep machine-specific secrets in separate `*.local` files that you source conditionally.

---

With these steps you have a clean, fast, and modern Zsh environment aligned with best practices for Apple Silicon macOS.
