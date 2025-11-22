# Justin’s macOS dotfiles

Opinionated dotfiles for a clean, reproducible macOS setup:

- Zsh with config in `~/.config/zsh` (via `ZDOTDIR`)
- Plugin-managed shell using [znap](https://github.com/marlonrichert/zsh-snap)
- Prompt via [starship](https://starship.rs/)
- SSH configured for 1Password agent (optional)
- Homebrew split into tiers (core / dev extras / apps)
- macOS defaults script scaffolded but not forced

This is meant for **fresh macOS installs** and for keeping one primary setup in sync over time.

---

## Quick start

Fresh machine, already have SSH access to GitHub and Homebrew not installed:

```sh
# 1. Install Homebrew (if you haven't yet)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone dotfiles
git clone git@github.com:jtutrow23/dotfiles.git ~/.dotfiles

# 3. Run the bootstrap
cd ~/.dotfiles
chmod +x install.sh
./install.sh
