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
  local helper

  while IFS= read -r helper || [[ -n "${helper:-}" ]]; do
    [[ -z "${helper:-}" || "${helper:0:1}" == "#" ]] && continue
    printf '%s\n' "$HOME/.local/bin/$helper|$REPO/bin/$helper|executable"
  done < "$REPO/manifests/helpers.txt"
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
