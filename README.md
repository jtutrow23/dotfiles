# macOS Dotfiles

Personal Apple Silicon macOS configuration.

## Contents

```text
Brewfile                     Homebrew formulae, casks and Mac App Store apps
zsh/.zprofile                Homebrew login-shell environment
zsh/.zshrc                   Interactive Zsh configuration
sheldon/plugins.toml         Zsh plugins
starship/starship.toml       Catppuccin Powerline prompt
ghostty/config.ghostty       Ghostty terminal configuration
mise/config.toml             Global Node/Python versions
docs/terminal-setup.md       Full terminal rebuild guide
docs/developer-tools.md      Runtime, Git and local-dev notes
docs/macos-preferences.md    Finder and login-banner preferences
```

## Fresh Mac

1. Install Apple Command Line Tools.
2. Install Homebrew.
3. Clone this repository to `~/.dotfiles`.
4. Run:

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

5. Follow:

```text
docs/terminal-setup.md
```

## Runtime policy

- Homebrew: applications, CLI utilities, services.
- mise: Node, Python and other language runtimes.

## Maintenance

Check the Brewfile:

```bash
brew bundle check --file=~/.dotfiles/Brewfile
```

Install anything missing:

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

Preview packages Homebrew considers extra:

```bash
brew bundle cleanup --file=~/.dotfiles/Brewfile
```

Run cleanup without `--force` first so removals can be reviewed.

## Secrets

Do not commit API keys, passwords, private SSH keys, tokens, or secret `.env` files.
