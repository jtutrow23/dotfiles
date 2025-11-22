# 🧩 Justin’s Dotfiles

A clean, portable macOS setup built around Zsh, Znap, Homebrew, and reproducible machine bootstrapping.  
Everything here is designed to make a fresh Mac fully configured in minutes.

---

## ⭐ Features

- **Zsh powered** — fast startup, plugin-managed via [Znap](https://github.com/marlonrichert/zsh-snap)  
- **Structured config** — all Zsh files live cleanly under `~/.config/zsh`  
- **Homebrew bundle** — curated formulae & casks separated into logical groups  
- **macOS defaults** script — applies UI/UX tweaks consistently  
- **Starship prompt** — fast, minimal, cross-shell  
- **Non-invasive** — everything symlinked using GNU Stow  
- **Works with SSH or HTTPS** — installable even on machines without SSH keys

---

## 🚀 Quick Install (SSH-enabled machines)

```sh
git clone git@github.com:jtutrow23/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./macos/bootstrap.sh
