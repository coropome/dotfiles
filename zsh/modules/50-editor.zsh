# Override via local.pre.zsh using AI_DEV_OS_EDITOR / AI_DEV_OS_FORCE_VIM when needed.
# DITFILES_* names remain supported for backward compatibility.
if [[ -n "${AI_DEV_OS_EDITOR:-}" ]]; then
  export EDITOR="$AI_DEV_OS_EDITOR"
  export VISUAL="$EDITOR"
elif [[ -n "${DITFILES_EDITOR:-}" ]]; then
  export EDITOR="$DITFILES_EDITOR"
  export VISUAL="$EDITOR"
elif [[ -n "${AI_DEV_OS_FORCE_VIM:-}" || -n "${DITFILES_FORCE_VIM:-}" ]] && has_cmd vim; then
  export EDITOR="vim"
  export VISUAL="$EDITOR"
elif [[ -z "${SSH_CONNECTION:-}" ]] && has_cmd code; then
  export EDITOR="code --wait"
  export VISUAL="$EDITOR"
elif has_cmd vim; then
  export EDITOR="vim"
  export VISUAL="$EDITOR"
fi
