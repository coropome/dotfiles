# Optional machine-local overrides.
# For env/PATH/editor overrides that should run earlier, use:
#   ~/.config/ditfiles/local.pre.zsh
# For final overrides after repo defaults, use:
#   ~/.config/ditfiles/local.zsh
#   ~/.config/ditfiles/local.post.zsh
if [[ -f "$HOME/.config/ditfiles/local.zsh" ]]; then
  source "$HOME/.config/ditfiles/local.zsh"
fi

if [[ -f "$HOME/.config/ditfiles/local.post.zsh" ]]; then
  source "$HOME/.config/ditfiles/local.post.zsh"
fi
