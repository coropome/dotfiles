setopt autocd
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
unsetopt menu_complete

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
