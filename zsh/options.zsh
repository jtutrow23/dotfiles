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
