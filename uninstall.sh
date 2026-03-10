#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$REPO/lib/bootstrap/common.sh"
source "$REPO/lib/bootstrap/manifest.sh"

echo "==> Removing ditfiles symlinks..."

remove_link() {
  local target="$1"
  local expected="$2"
  if same_link_target "$target" "$expected"; then
    rm "$target"
    echo "  Removed: $target"
  fi
}

remove_empty_dir() {
  local target="$1"
  if rmdir "$target" 2>/dev/null; then
    echo "  Removed empty dir: $target"
  fi
}

while IFS='|' read -r target expected _mode; do
  remove_link "$target" "$expected"
done < <(managed_link_specs)

echo "==> Removing git include entry..."
if git_include_present "$HOME/.config/ditfiles/gitconfig"; then
  git config --global --unset-all include.path "$HOME/.config/ditfiles/gitconfig" || true
  echo "  Removed git include"
fi

echo "==> Restoring most recent backups (if any)..."

restore_one() {
  local target="$1"
  local backups=()
  local latest
  shopt -s nullglob
  backups=( "${target}.bak."* )
  shopt -u nullglob
  if [[ ${#backups[@]} -eq 0 ]]; then
    return 0
  fi
  latest="${backups[0]}"
  for backup in "${backups[@]:1}"; do
    if [[ "$backup" -nt "$latest" ]]; then
      latest="$backup"
    fi
  done
  if [[ -n "$latest" ]]; then
    if [[ -e "$target" || -L "$target" ]]; then
      echo "  Skipped restore for $target (current file exists; keeping backup $latest)"
      return 0
    fi
    mv "$latest" "$target"
    echo "  Restored: $latest -> $target"
  fi
}

while IFS='|' read -r target _expected _mode; do
  restore_one "$target"
done < <(managed_link_specs)

remove_empty_dir "$HOME/.config/tmux"
remove_empty_dir "$HOME/.config/ditfiles"
remove_empty_dir "$HOME/.local/bin"

restore_one "$HOME/.config/tmux"
restore_one "$HOME/.config/ditfiles"
restore_one "$HOME/.local/bin"

remove_empty_dir "$HOME/.config"
remove_empty_dir "$HOME/.local"

restore_one "$HOME/.config"
restore_one "$HOME/.local"

echo ""
echo "Done. ditfiles removed."
echo "Open a new terminal to apply the restored settings."
