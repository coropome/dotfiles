# Override via local.pre.zsh using DITFILES_EDITOR / DITFILES_FORCE_VIM when needed.
if [[ -n "${DITFILES_EDITOR:-}" ]]; then
  export EDITOR="$DITFILES_EDITOR"
  export VISUAL="$EDITOR"
elif [[ -n "${DITFILES_FORCE_VIM:-}" ]] && has_cmd vim; then
  export EDITOR="vim"
  export VISUAL="$EDITOR"
elif [[ -z "${SSH_CONNECTION:-}" ]] && has_cmd code; then
  export EDITOR="code --wait"
  export VISUAL="$EDITOR"
elif has_cmd vim; then
  export EDITOR="vim"
  export VISUAL="$EDITOR"
fi
