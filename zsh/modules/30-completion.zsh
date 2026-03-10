autoload -Uz compinit
typeset -a DITFILES_ZCOMPDUMP_STALE
DITFILES_ZCOMPDUMP_STALE=("$HOME/.zcompdump"(N.mh+24))
if (( ${#DITFILES_ZCOMPDUMP_STALE[@]} )); then
  compinit
else
  compinit -C
fi
unset DITFILES_ZCOMPDUMP_STALE
zmodload zsh/complist

zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' accept-exact-dirs true

if [[ -n "${LS_COLORS:-}" ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
else
  zstyle ':completion:*' list-colors 'di=34:ln=36:ex=32:fi=0'
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
