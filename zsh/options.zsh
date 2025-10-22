# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zhistory"

# Sensible options
setopt hist_ignore_dups
setopt share_history
setopt inc_append_history
setopt interactive_comments
setopt auto_cd
setopt extended_glob
setopt no_beep

# Vi mode
bindkey -v
KEYTIMEOUT=1

# Fast, cached completion (quiet if cache missing)
autoload -Uz compinit
ZCOMP_CACHEDIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZCOMP_CACHEDIR"
# -C = skip security checks on comp dump (safe for single user), speeds login
compinit -d "$ZCOMP_CACHEDIR/zcompdump" -C 2>/dev/null