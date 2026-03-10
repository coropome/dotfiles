DITFILES_BREW_PREFIX="$(ditfiles_brew_prefix)"
ditfiles_source_first_existing \
  "${DITFILES_BREW_PREFIX:+$DITFILES_BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh}" \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  || true
unset DITFILES_BREW_PREFIX
