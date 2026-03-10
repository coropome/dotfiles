if has_cmd eza; then
  export EZA_COLORS='di=1;34:ln=1;36:ex=1;32:sn=1;35:uu=33:gu=33'
  alias ls='eza --group-directories-first --icons=never --classify=always'
  alias ll='eza -lh --header --icons=never --group-directories-first --time-style=relative --classify=always'
  alias la='eza -a --group-directories-first --icons=never --classify=always'
  alias lla='eza -lah --header --icons=never --group-directories-first --time-style=relative --classify=always'
  alias lg='eza -lah --header --git --icons=never --group-directories-first --time-style=relative --classify=always'
  alias lt='eza --tree --icons=never --group-directories-first -L 2 --classify=always'
  alias llt='eza --tree -lah --icons=never --group-directories-first -L 2 --classify=always'
  alias lsd='eza -D --icons=never --classify=always'
fi

if has_cmd fzf; then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  else
    DITFILES_BREW_PREFIX="$(ditfiles_brew_prefix)"
    ditfiles_source_all_existing \
      "${DITFILES_BREW_PREFIX:+$DITFILES_BREW_PREFIX/opt/fzf/shell/completion.zsh}" \
      /usr/share/fzf/completion.zsh \
      /usr/local/share/fzf/completion.zsh \
      || true
    ditfiles_source_all_existing \
      "${DITFILES_BREW_PREFIX:+$DITFILES_BREW_PREFIX/opt/fzf/shell/key-bindings.zsh}" \
      /usr/share/fzf/key-bindings.zsh \
      /usr/local/share/fzf/key-bindings.zsh \
      || true
    unset DITFILES_BREW_PREFIX
  fi
fi

if has_cmd zoxide; then
  eval "$(zoxide init zsh)"
fi

if has_cmd bat; then
  alias ccat='bat --paging=never --style=plain'
fi

if has_cmd lazydocker; then
  alias ld='lazydocker'
fi
