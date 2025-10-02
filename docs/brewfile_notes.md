# 🍺 Brewfile Notes

This document explains the intent behind your `Brewfile` and how to use it repeatably.

## Usage
cd ~/dotfiles
brew bundle --file=~/dotfiles/Brewfile

To regenerate from your current machine:
brew bundle dump --force --file=~/dotfiles/Brewfile

## Structure Overview
- **Taps**: consistent sources for formulas/casks.
- **CLI**: core terminal tools (speed, dev, quality-of-life).
- **Dev/Ops**: build toolchain & SSL.
- **Casks**: GUI apps.
- **MAS**: (optional) App Store installs via `mas`.
- **Postinstall**: one-off steps (e.g., fzf keybindings) that don’t touch your rc files.

## Line-by-line Highlights

### CLI
- `zsh` — keep latest Zsh pinned
- `starship` — prompt styled by your config
- `fzf`, `fd`, `ripgrep`, `bat`, `eza` — modern search/listing tools
- `zoxide` — smarter `cd`
- `git`, `git-delta`, `lazygit` — Git workflow
- `btop`, `tree`, `jq` — monitoring and inspection
- `neovim` — editor (with repo config)
- `python@3.12`, `node`, `mise` — runtimes

### Casks
- `iterm2`, `raycast`, `rectangle`, `karabiner-elements`, `docker`
- Browsers: `arc`, `google-chrome`, `firefox`
- Media: `spotify`, `vlc`

### Postinstall
- fzf installer (keybindings/completions only, no rc edits)

## Tips
- Keep intentional and minimal.
- Use `brew bundle cleanup` to prune unused software.
