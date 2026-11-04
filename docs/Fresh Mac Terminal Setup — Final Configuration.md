# Fresh Mac Terminal Setup

This reproduces the finished setup:

**Homebrew Zsh + Starship + Sheldon + fzf/fzf-tab + zoxide + eza + bat + modern CLI tools + Meslo Nerd Font**

---

# 1. Install Apple Command Line Tools

Open Terminal and run:

```bash
xcode-select --install
```

If macOS says they're already installed, that's fine.

Verify:

```bash
xcode-select -p
```

Expected:

```text
starship
sheldon
fzf
eza
zoxide
bat
ripgrep
fd
dust
bottom
jq
tree
wget
git
gh
==> Updating Homebrew...
Already up-to-date.
Usage: brew install [options] formula|cask [...]

Install a formula or cask. Additional options specific to a formula may be
appended to the command.

Unless $HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK is set, brew upgrade or brew
reinstall will be run for outdated dependents and dependents with broken
linkage, respectively.

Unless $HOMEBREW_NO_INSTALL_CLEANUP is set, brew cleanup will then be run
for the installed formulae and casks or, every 30 days, for all packages.

Unless $HOMEBREW_NO_INSTALL_UPGRADE is set, brew install formula will
upgrade formula if it is already installed but outdated.

  -d, --debug                      If brewing fails, open an interactive
                                   debugging session with access to IRB or a
                                   shell inside the temporary build directory.
      --display-times              Print install times for each package at the
                                   end of the run. Enabled by default if
                                   $HOMEBREW_DISPLAY_INSTALL_TIMES is set.
  -f, --force                      Install formulae without checking for
                                   previously installed keg-only or non-migrated
                                   versions. When installing casks, overwrite
                                   existing files (binaries and symlinks are
                                   excluded, unless originally from the same
                                   cask).
  -v, --verbose                    Print the verification and post-install
                                   steps.
  -n, --dry-run                    Show what would be installed, but do not
                                   actually install anything.
  -y, --no-ask, --yes              Do not ask for confirmation before
                                   downloading and installing. Ask mode is the
                                   default. Enabled by default if
                                   $HOMEBREW_NO_ASK is set.
      --formula, --formulae        Treat all named arguments as formulae.
      --ignore-dependencies        An unsupported Homebrew development option to
                                   skip installing any dependencies of any kind.
                                   If the dependencies are not already present,
                                   the formula will have issues. If you're not
                                   developing Homebrew, consider adjusting your
                                   PATH rather than using this option.
      --only-dependencies          Install the dependencies with specified
                                   options but do not install the formula
                                   itself.
      --cc                         Attempt to compile using the specified
                                   compiler, which should be the name of the
                                   compiler's executable, e.g. gcc-9 for GCC
                                   9. In order to use LLVM's clang, specify
                                   llvm_clang. To use the Apple-provided
                                   clang, specify clang. This option will only
                                   accept compilers that are provided by
                                   Homebrew or bundled with macOS. Please do not
                                   file issues if you encounter errors while
                                   using this option.
  -s, --build-from-source          Compile formula from source even if a
                                   bottle is provided. Dependencies will still
                                   be installed from bottles if they are
                                   available.
      --force-bottle               Install from a bottle if it exists for the
                                   current or newest version of macOS, even if
                                   it would not normally be used for
                                   installation.
      --include-test               Install testing dependencies required to run
                                   brew test formula.
      --HEAD                       If formula defines it, install the HEAD
                                   version, aka. main, trunk, unstable, master.
      --fetch-HEAD                 Fetch the upstream repository to detect if
                                   the HEAD installation of the formula is
                                   outdated. Otherwise, the repository's HEAD
                                   will only be checked for updates when a new
                                   stable or development version has been
                                   released.
      --keep-tmp                   Retain the temporary files created during
                                   installation.
      --debug-symbols              Generate debug symbols on build. Source will
                                   be retained in a cache directory.
      --build-bottle               Prepare the formula for eventual bottling
                                   during installation, skipping any
                                   post-install steps.
      --skip-post-install          Install but skip any post-install steps.
      --skip-link                  Install but skip linking the keg into the
                                   prefix.
      --as-dependency              Install but mark as installed as a dependency
                                   and not installed on request.
      --bottle-arch                Optimise bottles for the specified
                                   architecture rather than the oldest
                                   architecture supported by the version of
                                   macOS the bottles are built on.
  -i, --interactive                Download and patch formula, then open a
                                   shell. This allows the user to run
                                   ./configure --help and otherwise determine
                                   how to turn the software package into a
                                   Homebrew package.
  -g, --git                        Create a Git repository, useful for creating
                                   patches to the software.
      --overwrite                  Delete files that already exist in the prefix
                                   while linking.
      --cask, --casks              Treat all named arguments as casks.
      --[no-]binaries              Disable/enable linking of helper executables
                                   (default: enabled).
      --require-sha                Require all casks to have a checksum.
      --adopt                      Adopt existing artifacts in the destination
                                   that are identical to those being installed.
                                   Cannot be combined with --force.
      --skip-cask-deps             Skip installing cask dependencies.
      --zap                        For use with brew reinstall --cask. Remove
                                   all files associated with a cask. May remove
                                   files which are shared between applications.
      --appdir                     Target location for Applications (default:
                                   /Applications).
      --appimagedir                Target location for AppImages (default:
                                   ~/Applications).
      --keyboard-layoutdir         Target location for Keyboard Layouts
                                   (default: /Library/Keyboard Layouts).
      --colorpickerdir             Target location for Color Pickers (default:
                                   ~/Library/ColorPickers).
      --prefpanedir                Target location for Preference Panes
                                   (default: ~/Library/PreferencePanes).
      --qlplugindir                Target location for Quick Look Plugins
                                   (default: ~/Library/QuickLook).
      --mdimporterdir              Target location for Spotlight Plugins
                                   (default: ~/Library/Spotlight).
      --dictionarydir              Target location for Dictionaries (default:
                                   ~/Library/Dictionaries).
      --fontdir                    Target location for Fonts (default:
                                   ~/Library/Fonts).
      --servicedir                 Target location for Services (default:
                                   ~/Library/Services).
      --input-methoddir            Target location for Input Methods (default:
                                   ~/Library/Input Methods).
      --internet-plugindir         Target location for Internet Plugins
                                   (default: ~/Library/Internet Plug-Ins).
      --audio-unit-plugindir       Target location for Audio Unit Plugins
                                   (default:
                                   ~/Library/Audio/Plug-Ins/Components).
      --vst-plugindir              Target location for VST Plugins (default:
                                   ~/Library/Audio/Plug-Ins/VST).
      --vst3-plugindir             Target location for VST3 Plugins (default:
                                   ~/Library/Audio/Plug-Ins/VST3).
      --screen-saverdir            Target location for Screen Savers (default:
                                   ~/Library/Screen Savers).
      --language                   Comma-separated list of language codes to
                                   prefer for cask installation. The first
                                   matching language is used, otherwise it
                                   reverts to the cask's default language. The
                                   default value is the language of your system.
  -q, --quiet                      Make some output more quiet.
  -h, --help                       Show this message.

Error: Invalid usage: This command requires at least 1 formula or cask argument.
zsh: command not found: starship
zsh: command not found: sheldon
zsh: command not found: fzf
zsh: command not found: eza
zsh: command not found: zoxide
zsh: command not found: bat
zsh: command not found: ripgrep
zsh: command not found: fd
zsh: command not found: dust
zsh: command not found: bottom
jq - commandline JSON processor [version 1.7.1-apple]

Usage:	jq [options] <jq filter> [file...]
	jq [options] --args <jq filter> [strings...]
	jq [options] --jsonargs <jq filter> [JSON_TEXTS...]

jq is a tool for processing JSON inputs, applying the given filter to
its JSON text inputs and producing the filter's results as JSON on
standard output.

The simplest filter is ., which copies jq's input to its output
unmodified except for formatting. For more advanced filters see
the jq(1) manpage ("man jq") and/or https://jqlang.github.io/jq/.

Example:

	$ echo '{"foo": 0}' | jq .
	{
	  "foo": 0
	}

For listing the command options, use jq --help.
zsh: command not found: tree
zsh: command not found: wget
usage: git [-v | --version] [-h | --help] [-C <path>] [-c <name>=<value>]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--no-lazy-fetch]
           [--no-optional-locks] [--no-advice] [--bare] [--git-dir=<path>]
           [--work-tree=<path>] [--namespace=<name>] [--config-env=<name>=<envvar>]
           <command> [<args>]

These are common Git commands used in various situations:

start a working area (see also: git help tutorial)
   clone      Clone a repository into a new directory
   init       Create an empty Git repository or reinitialize an existing one

work on the current change (see also: git help everyday)
   add        Add file contents to the index
   mv         Move or rename a file, a directory, or a symlink
   restore    Restore working tree files
   rm         Remove files from the working tree and from the index

examine the history and state (see also: git help revisions)
   bisect     Use binary search to find the commit that introduced a bug
   diff       Show changes between commits, commit and working tree, etc
   grep       Print lines matching a pattern
   log        Show commit logs
   show       Show various types of objects
   status     Show the working tree status

grow, mark and tweak your common history
   backfill   Download missing objects in a partial clone
   branch     List, create, or delete branches
   commit     Record changes to the repository
   merge      Join two or more development histories together
   rebase     Reapply commits on top of another base tip
   reset      Reset current HEAD to the specified state
   switch     Switch branches
   tag        Create, list, delete or verify a tag object signed with GPG

collaborate (see also: git help workflows)
   fetch      Download objects and refs from another repository
   pull       Fetch from and integrate with another repository or a local branch
   push       Update remote refs along with associated objects

'git help -a' and 'git help -g' list available subcommands and some
concept guides. See 'git help <command>' or 'git help <concept>'
to read about a specific subcommand or concept.
See 'git help git' for an overview of the system.
zsh: command not found: gh
jtutrow23@Justins-MacBook-Air ~ % brew install
starship
sheldon
fzf
eza
zoxide
bat
ripgrep
fd
dust
bottom
jq
tree
wget
git
gh
Usage: brew install [options] formula|cask [...]

Install a formula or cask. Additional options specific to a formula may be
appended to the command.

Unless $HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK is set, brew upgrade or brew
reinstall will be run for outdated dependents and dependents with broken
linkage, respectively.

Unless $HOMEBREW_NO_INSTALL_CLEANUP is set, brew cleanup will then be run
for the installed formulae and casks or, every 30 days, for all packages.

Unless $HOMEBREW_NO_INSTALL_UPGRADE is set, brew install formula will
upgrade formula if it is already installed but outdated.

  -d, --debug                      If brewing fails, open an interactive
                                   debugging session with access to IRB or a
                                   shell inside the temporary build directory.
      --display-times              Print install times for each package at the
                                   end of the run. Enabled by default if
                                   $HOMEBREW_DISPLAY_INSTALL_TIMES is set.
  -f, --force                      Install formulae without checking for
                                   previously installed keg-only or non-migrated
                                   versions. When installing casks, overwrite
                                   existing files (binaries and symlinks are
                                   excluded, unless originally from the same
                                   cask).
  -v, --verbose                    Print the verification and post-install
                                   steps.
  -n, --dry-run                    Show what would be installed, but do not
                                   actually install anything.
  -y, --no-ask, --yes              Do not ask for confirmation before
                                   downloading and installing. Ask mode is the
                                   default. Enabled by default if
                                   $HOMEBREW_NO_ASK is set.
      --formula, --formulae        Treat all named arguments as formulae.
      --ignore-dependencies        An unsupported Homebrew development option to
                                   skip installing any dependencies of any kind.
                                   If the dependencies are not already present,
                                   the formula will have issues. If you're not
                                   developing Homebrew, consider adjusting your
                                   PATH rather than using this option.
      --only-dependencies          Install the dependencies with specified
                                   options but do not install the formula
                                   itself.
      --cc                         Attempt to compile using the specified
                                   compiler, which should be the name of the
                                   compiler's executable, e.g. gcc-9 for GCC
                                   9. In order to use LLVM's clang, specify
                                   llvm_clang. To use the Apple-provided
                                   clang, specify clang. This option will only
                                   accept compilers that are provided by
                                   Homebrew or bundled with macOS. Please do not
                                   file issues if you encounter errors while
                                   using this option.
  -s, --build-from-source          Compile formula from source even if a
                                   bottle is provided. Dependencies will still
                                   be installed from bottles if they are
                                   available.
      --force-bottle               Install from a bottle if it exists for the
                                   current or newest version of macOS, even if
                                   it would not normally be used for
                                   installation.
      --include-test               Install testing dependencies required to run
                                   brew test formula.
      --HEAD                       If formula defines it, install the HEAD
                                   version, aka. main, trunk, unstable, master.
      --fetch-HEAD                 Fetch the upstream repository to detect if
                                   the HEAD installation of the formula is
                                   outdated. Otherwise, the repository's HEAD
                                   will only be checked for updates when a new
                                   stable or development version has been
                                   released.
      --keep-tmp                   Retain the temporary files created during
                                   installation.
      --debug-symbols              Generate debug symbols on build. Source will
                                   be retained in a cache directory.
      --build-bottle               Prepare the formula for eventual bottling
                                   during installation, skipping any
                                   post-install steps.
      --skip-post-install          Install but skip any post-install steps.
      --skip-link                  Install but skip linking the keg into the
                                   prefix.
      --as-dependency              Install but mark as installed as a dependency
                                   and not installed on request.
      --bottle-arch                Optimise bottles for the specified
                                   architecture rather than the oldest
                                   architecture supported by the version of
                                   macOS the bottles are built on.
  -i, --interactive                Download and patch formula, then open a
                                   shell. This allows the user to run
                                   ./configure --help and otherwise determine
                                   how to turn the software package into a
                                   Homebrew package.
  -g, --git                        Create a Git repository, useful for creating
                                   patches to the software.
      --overwrite                  Delete files that already exist in the prefix
                                   while linking.
      --cask, --casks              Treat all named arguments as casks.
      --[no-]binaries              Disable/enable linking of helper executables
                                   (default: enabled).
      --require-sha                Require all casks to have a checksum.
      --adopt                      Adopt existing artifacts in the destination
                                   that are identical to those being installed.
                                   Cannot be combined with --force.
      --skip-cask-deps             Skip installing cask dependencies.
      --zap                        For use with brew reinstall --cask. Remove
                                   all files associated with a cask. May remove
                                   files which are shared between applications.
      --appdir                     Target location for Applications (default:
                                   /Applications).
      --appimagedir                Target location for AppImages (default:
                                   ~/Applications).
      --keyboard-layoutdir         Target location for Keyboard Layouts
                                   (default: /Library/Keyboard Layouts).
      --colorpickerdir             Target location for Color Pickers (default:
                                   ~/Library/ColorPickers).
      --prefpanedir                Target location for Preference Panes
                                   (default: ~/Library/PreferencePanes).
      --qlplugindir                Target location for Quick Look Plugins
                                   (default: ~/Library/QuickLook).
      --mdimporterdir              Target location for Spotlight Plugins
                                   (default: ~/Library/Spotlight).
      --dictionarydir              Target location for Dictionaries (default:
                                   ~/Library/Dictionaries).
      --fontdir                    Target location for Fonts (default:
                                   ~/Library/Fonts).
      --servicedir                 Target location for Services (default:
                                   ~/Library/Services).
      --input-methoddir            Target location for Input Methods (default:
                                   ~/Library/Input Methods).
      --internet-plugindir         Target location for Internet Plugins
                                   (default: ~/Library/Internet Plug-Ins).
      --audio-unit-plugindir       Target location for Audio Unit Plugins
                                   (default:
                                   ~/Library/Audio/Plug-Ins/Components).
      --vst-plugindir              Target location for VST Plugins (default:
                                   ~/Library/Audio/Plug-Ins/VST).
      --vst3-plugindir             Target location for VST3 Plugins (default:
                                   ~/Library/Audio/Plug-Ins/VST3).
      --screen-saverdir            Target location for Screen Savers (default:
                                   ~/Library/Screen Savers).
      --language                   Comma-separated list of language codes to
                                   prefer for cask installation. The first
                                   matching language is used, otherwise it
                                   reverts to the cask's default language. The
                                   default value is the language of your system.
  -q, --quiet                      Make some output more quiet.
  -h, --help                       Show this message.

Error: Invalid usage: This command requires at least 1 formula or cask argument.
zsh: command not found: starship
zsh: command not found: sheldon
zsh: command not found: fzf
zsh: command not found: eza
zsh: command not found: zoxide
zsh: command not found: bat
zsh: command not found: ripgrep
zsh: command not found: fd
zsh: command not found: dust
zsh: command not found: bottom
jq - commandline JSON processor [version 1.7.1-apple]

Usage:	jq [options] <jq filter> [file...]
	jq [options] --args <jq filter> [strings...]
	jq [options] --jsonargs <jq filter> [JSON_TEXTS...]

jq is a tool for processing JSON inputs, applying the given filter to
its JSON text inputs and producing the filter's results as JSON on
standard output.

The simplest filter is ., which copies jq's input to its output
unmodified except for formatting. For more advanced filters see
the jq(1) manpage ("man jq") and/or https://jqlang.github.io/jq/.

Example:

	$ echo '{"foo": 0}' | jq .
	{
	  "foo": 0
	}

For listing the command options, use jq --help.
zsh: command not found: tree
zsh: command not found: wget
usage: git [-v | --version] [-h | --help] [-C <path>] [-c <name>=<value>]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--no-lazy-fetch]
           [--no-optional-locks] [--no-advice] [--bare] [--git-dir=<path>]
           [--work-tree=<path>] [--namespace=<name>] [--config-env=<name>=<envvar>]
           <command> [<args>]

These are common Git commands used in various situations:

start a working area (see also: git help tutorial)
   clone      Clone a repository into a new directory
   init       Create an empty Git repository or reinitialize an existing one

work on the current change (see also: git help everyday)
   add        Add file contents to the index
   mv         Move or rename a file, a directory, or a symlink
   restore    Restore working tree files
   rm         Remove files from the working tree and from the index

examine the history and state (see also: git help revisions)
   bisect     Use binary search to find the commit that introduced a bug
   diff       Show changes between commits, commit and working tree, etc
   grep       Print lines matching a pattern
   log        Show commit logs
   show       Show various types of objects
   status     Show the working tree status

grow, mark and tweak your common history
   backfill   Download missing objects in a partial clone
   branch     List, create, or delete branches
   commit     Record changes to the repository
   merge      Join two or more development histories together
   rebase     Reapply commits on top of another base tip
   reset      Reset current HEAD to the specified state
   switch     Switch branches
   tag        Create, list, delete or verify a tag object signed with GPG

collaborate (see also: git help workflows)
   fetch      Download objects and refs from another repository
   pull       Fetch from and integrate with another repository or a local branch
   push       Update remote refs along with associated objects

'git help -a' and 'git help -g' list available subcommands and some
concept guides. See 'git help <command>' or 'git help <concept>'
to read about a specific subcommand or concept.
See 'git help git' for an overview of the system.
zsh: command not found: gh/Library/Developer/CommandLineTools
```

Check the Mac architecture:

```bash
uname -m
```

On Apple Silicon:

```text
arm64
```

---

# 2. Install Homebrew

On a fresh Mac:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

For Apple Silicon, configure Homebrew:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
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

# 3. Use Homebrew Zsh

To reproduce the final setup exactly:

```bash
brew install zsh
```

Register it as an allowed login shell:

```bash
grep -qxF '/opt/homebrew/bin/zsh' /etc/shells || \
  echo '/opt/homebrew/bin/zsh' | sudo tee -a /etc/shells
```

Set it as your shell:

```bash
chsh -s /opt/homebrew/bin/zsh
```

Close Terminal and reopen it.

Verify:

```bash
echo $SHELL
```

Expected:

```text
/opt/homebrew/bin/zsh
```

---

# 4. Install the CLI Toolkit

```bash
brew update

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

macOS already includes `curl`, so there is no need to replace it just for this setup.

Verify the important tools:

```bash
starship --version
sheldon --version
fzf --version
eza --version
zoxide --version
bat --version
rg --version
fd --version
dust --version
btm --version
jq --version
git --version
gh --version
```

---

# 5. Install Meslo Nerd Font

```bash
brew install --cask font-meslo-lg-nerd-font
```

In Terminal.app open:

**Terminal → Settings → Profiles → Text → Font**

Choose:

```text
MesloLGS Nerd Font
```

Around **14 pt** works well.

---

# 6. Configure `.zprofile`

Your `~/.zprofile` should contain:

```zsh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

You can inspect it with:

```bash
cat ~/.zprofile
```

Homebrew belongs here, so we don't duplicate its initialization in `.zshrc`.

---

# 7. Configure Sheldon

Create its configuration directory:

```bash
mkdir -p ~/.config/sheldon
```

Create:

```bash
nano ~/.config/sheldon/plugins.toml
```

Paste:

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

Save with:

```text
Control-O
Enter
Control-X
```

The resulting plugin stack is:

```text
fzf-tab
zsh-autosuggestions
zsh-syntax-highlighting
```

---

# 8. Create the Final `.zshrc`

Open:

```bash
nano ~/.zshrc
```

Use this configuration:

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

Reload:

```bash
exec zsh
```

The first reload may show Sheldon cloning its plugins. That's expected.

---

# 9. Configure the Final Starship Theme

Create:

```bash
mkdir -p ~/.config
nano ~/.config/starship.toml
```

Paste:

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

Reload:

```bash
exec zsh
```

The finished prompt should roughly resemble:

```text
   ~/Projects/app   main +1   v24.x  󱎫 3s     󰁹 87%  09:54 PM
❯
```

The language/runtime sections only appear when relevant.

---

# 10. Silence the macOS Last Login Message

Create:

```bash
touch ~/.hushlogin
```

Open a new Terminal window.

This removes messages such as:

```text
Last login: Wed Sep 9 05:35:30 on ttys000
```

To restore them later:

```bash
rm ~/.hushlogin
```

---

# 11. Test Everything

Test the shell:

```bash
echo "shell works"
```

Test modern listings:

```bash
ls
ll
lt
```

Test bat:

```bash
cat ~/.zshrc
```

Test zoxide:

```bash
mkdir -p ~/Desktop/zoxide-test
cd ~/Desktop/zoxide-test
cd ~
z zoxide
```

You should jump back into:

```text
~/Desktop/zoxide-test
```

When finished testing:

```bash
rm -rf ~/Desktop/zoxide-test
```

Test fzf:

**Ctrl-R**

opens fuzzy command-history search.

**Ctrl-T**

opens fuzzy file selection with `bat` previews.

**Option-C / Alt-C**

opens fuzzy directory navigation with `eza` previews.

Test fzf-tab by typing:

```text
cd ~/
```

and pressing **Tab**.

You should get fuzzy completion with directory previews.

Test command-duration display:

```bash
sleep 3
```

The next Starship prompt should show approximately:

```text
󱎫 3s
```

---

# Final File Layout

```text
~/.zprofile
└── Homebrew environment

~/.zshrc
├── environment
├── history
├── completion
├── fzf
├── zoxide
├── aliases
├── Sheldon
├── fzf-tab configuration
└── Starship initialization

~/.config/sheldon/plugins.toml
├── fzf-tab
├── zsh-autosuggestions
└── zsh-syntax-highlighting

~/.config/starship.toml
└── Catppuccin Mocha Powerline prompt

~/.hushlogin
└── hides macOS Last Login message
```

The terminal stack is now:

```text
Terminal.app
    │
    └── Homebrew Zsh
        │
        ├── Starship
        │   └── Catppuccin Powerline prompt
        │
        ├── Sheldon
        │   ├── fzf-tab
        │   ├── zsh-autosuggestions
        │   └── zsh-syntax-highlighting
        │
        ├── fzf
        │   ├── history search
        │   ├── file search + previews
        │   └── directory search + previews
        │
        ├── zoxide
        │
        └── Modern CLI tools
            ├── eza
            ├── bat
            ├── ripgrep
            ├── fd
            ├── dust
            ├── bottom
            ├── jq
            ├── git
            └── gh
```

At this point the **terminal configuration itself is finished**. Future additions such as SSH/GitHub authentication, `lazygit`, `mise`, Node/Python tooling, Docker, or eventually Ghostty should be treated as separate developer-tooling upgrades rather than continuing to modify the core shell.
