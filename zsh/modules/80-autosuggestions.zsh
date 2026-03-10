DITFILES_BREW_PREFIX="$(ditfiles_brew_prefix)"
ditfiles_source_first_existing \
  "${DITFILES_BREW_PREFIX:+$DITFILES_BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh}" \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  || true
unset DITFILES_BREW_PREFIX
