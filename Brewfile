tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/core"

# ---------- CLI ----------
brew "zsh"                    # shell (system zsh is fine, but keep pinned here)
brew "starship"               # prompt
brew "fzf"                    # fuzzy finder
brew "zoxide"                 # smarter cd
brew "fd"                     # fast find
brew "ripgrep"                # fast grep
brew "bat"                    # pretty cat
brew "eza"                    # modern ls
brew "jq"                     # JSON CLI swiss army knife
brew "btop"                   # system monitor
brew "git"                    # latest Git
brew "git-delta"              # pager for git diffs
brew "lazygit"                # TUI git
brew "tree"                   # directory tree
brew "neovim"                 # your editor
brew "python@3.12"            # stable python
brew "node"                   # JS runtime (use mise if preferred)
brew "mise"                   # version/runtime manager (optional)

# ---------- Dev/ops ----------
brew "openssl@3"
brew "cmake"
brew "pkg-config"

# ---------- Casks (GUI apps) ----------
cask "iterm2"                 # or wezterm/kitty if you prefer
cask "raycast"
cask "rectangle"              # window manager
cask "karabiner-elements"     # keyboard remapping (optional)
cask "docker"                 # containers
cask "arc"                    # browser (optional)
cask "google-chrome"          # browser
cask "firefox"                # browser
cask "spotify"                # media
cask "vlc"                    # media

# ---------- Mac App Store (uncomment and set your app IDs) ----------
# brew "mas"
# mas "Xcode", id: 497799835
# mas "TestFlight", id: 899247664

# ---------- Post-install hooks ----------
# fzf key-bindings (safe, no rc edits)
postinstall "yes | /opt/homebrew/opt/fzf/install --no-bash --no-fish --key-bindings --completion --no-update-rc || true"
