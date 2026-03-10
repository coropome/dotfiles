#!/usr/bin/env bash

# Shared helpers for locating the repository and resolving repo-relative paths.

dotfiles_repo_root() {
  local source_path="${1:-${BASH_SOURCE[0]}}"
  (
    cd "$(dirname "$source_path")/../.." &&
    pwd -P
  )
}

dotfiles_repo_path() {
  local relative_path="$1"
  printf "%s/%s\n" "$(dotfiles_repo_root "${BASH_SOURCE[0]}")" "$relative_path"
}
