#!/usr/bin/env bash

managed_config_specs() {
  printf '%s\n' \
    "$HOME/.zprofile|$REPO/.zprofile|" \
    "$HOME/.zshrc|$REPO/zsh/zshrc|" \
    "$HOME/.config/tmux/tmux.conf|$REPO/tmux/tmux.conf|" \
    "$HOME/.config/tmux/conf.d|$REPO/tmux/conf.d|" \
    "$HOME/.config/ditfiles/gitconfig|$REPO/git/gitconfig|" \
    "$HOME/.config/ditfiles/conf.d|$REPO/git/conf.d|" \
    "$HOME/.config/ditfiles/gitignore_global|$REPO/git/gitignore_global|" \
    "$HOME/.config/starship.toml|$REPO/zsh/starship.toml|"
}

managed_helper_specs() {
  printf '%s\n' \
    "$HOME/.local/bin/tnew|$REPO/bin/tnew|executable" \
    "$HOME/.local/bin/thelp|$REPO/bin/thelp|executable" \
    "$HOME/.local/bin/tlist|$REPO/bin/tlist|executable" \
    "$HOME/.local/bin/tgo|$REPO/bin/tgo|executable" \
    "$HOME/.local/bin/tkill|$REPO/bin/tkill|executable" \
    "$HOME/.local/bin/_tpick|$REPO/bin/_tpick|executable" \
    "$HOME/.local/bin/ttutor|$REPO/bin/ttutor|executable" \
    "$HOME/.local/bin/p|$REPO/bin/p|executable" \
    "$HOME/.local/bin/_platform|$REPO/bin/_platform|executable" \
    "$HOME/.local/bin/_clipboard_copy|$REPO/bin/_clipboard_copy|executable" \
    "$HOME/.local/bin/_open|$REPO/bin/_open|executable" \
    "$HOME/.local/bin/_tmux_help|$REPO/bin/_tmux_help|executable"
}

managed_link_specs() {
  managed_config_specs
  managed_helper_specs
}

tmux_plugin_specs() {
  printf '%s\n' \
    "TPM|https://github.com/tmux-plugins/tpm|$HOME/.tmux/plugins/tpm|tpm" \
    "tmux-resurrect|https://github.com/tmux-plugins/tmux-resurrect|$HOME/.tmux/plugins/tmux-resurrect|" \
    "tmux-continuum|https://github.com/tmux-plugins/tmux-continuum|$HOME/.tmux/plugins/tmux-continuum|"
}
