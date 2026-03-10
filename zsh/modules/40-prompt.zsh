if has_cmd starship; then
  eval "$(starship init zsh)"
else
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:git:*' formats '(%b)'
  precmd() { vcs_info }
  setopt PROMPT_SUBST
  PROMPT='%n@%m %F{olive}%~%f ${vcs_info_msg_0_}%# '
fi
