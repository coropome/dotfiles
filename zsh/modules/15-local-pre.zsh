# Optional machine-local env overrides that should run before prompt/tool init:
#   ~/.config/ditfiles/local.pre.zsh
if [[ -f "$HOME/.config/ditfiles/local.pre.zsh" ]]; then
  source "$HOME/.config/ditfiles/local.pre.zsh"
fi
