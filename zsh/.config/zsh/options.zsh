# ── Core behaviour ──────────────────────────────────────────────────────
setopt autocd                 # 'cd dir' → just 'dir'
setopt interactive_comments   # allow comments in interactive shell
setopt extended_glob          # better globbing
setopt prompt_subst           # allow $(...) etc in prompt
setopt no_beep                # nobody wants the bell

# ── History ─────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt share_history          # share history across sessions
setopt hist_ignore_all_dups   # don't keep duplicates
setopt hist_reduce_blanks     # strip extra spaces

# ── Completion ──────────────────────────────────────────────────────────
autoload -Uz compinit
# Use a fixed compdump so it's cacheable
compinit -d "$ZDOTDIR/.zcompdump"

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Show a menu when there are multiple matches
zstyle ':completion:*' menu select

# ── Sanity: no “did you mean” correction ───────────────────────────────
unsetopt correct_all
unsetopt correct