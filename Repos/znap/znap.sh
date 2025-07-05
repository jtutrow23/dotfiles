#!/bin/zsh

# ─── 📦 Bootstrapped Homebrew Zsh Environment (Apple Silicon) ────────────────

# ✅ 1. Ensure Znap is Installed
[[ -r ~/Repos/znap/znap.zsh ]] || \
    git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh

# ✅ 2. Optional: Configure Where Plugins Are Stored
zstyle ':znap:*' repos-dir ~/Repos
# zstyle ':znap:*' auto-compile no  # Uncomment if you want to disable async compile

# ✅ 3. Prompt (Fast loading prompt)
znap prompt sindresorhus/pure

# ✅ 4. Plugin Sources (Lazy-load)
znap source zsh-users/zsh-autosuggestions       # inline suggestion
znap source zsh-users/zsh-syntax-highlighting   # highlight syntax
znap source jeffreytse/zsh-vi-mode              # vi-style navigation
znap source Aloxaf/fzf-tab                      # fzf-tab completion
znap source marlonrichert/zsh-autocomplete      # smart autocomplete
znap source hlissner/zsh-autopair               # auto-close brackets, quotes

# ✅ 5. Optional Tooling: Cached Evaluations
# znap eval mise 'mise activate zsh'

# ✅ 6. Optional Lazy Loading Hooks (e.g. Pyenv)
# znap function _pyenv pyenv "znap eval pyenv 'pyenv init - --no-rehash'"
# compctl -K _pyenv pyenv

# ✅ 7. Path & Fpath Additions (if needed)
# path=(~/bin $path)
# fpath=(~/.zsh/completions $fpath)

# ✅ 8. Completions Behavior (Optional)
# zstyle '*:compinit' arguments -D -i -u -C -w

# ✅ 9. Prompt Appearance Tweaks (optional)
# PURE_PROMPT_SYMBOL="❯"
# PURE_GIT_DOWN_ARROW=""
# PURE_GIT_UP_ARROW=""

# ✅ 10. Update All Plugins With:
# znap pull

# ✅ 11. Check Plugin Status With:
# znap status

# ─────────────────────────────────────────────────────────────────────────────