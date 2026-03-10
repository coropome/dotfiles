#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_exists() {
  local path="$1"
  [[ -e "$path" || -L "$path" ]] || fail "missing: $path"
}

assert_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "expected file: $path"
}

assert_dir() {
  local path="$1"
  [[ -d "$path" ]] || fail "expected directory: $path"
}

assert_executable() {
  local path="$1"
  [[ -x "$path" ]] || fail "expected executable: $path"
}

verify_links_manifest() {
  local manifest="$REPO/manifests/bootstrap/links.tsv"
  local line target source type source_path
  local -a targets=()

  assert_file "$manifest"

  while IFS=$'\t' read -r target source type || [[ -n "${target:-}" ]]; do
    [[ -z "${target:-}" || "${target:0:1}" == "#" ]] && continue

    source_path="$REPO/$source"
    case "$type" in
      file)
        assert_file "$source_path"
        ;;
      executable)
        assert_file "$source_path"
        assert_executable "$source_path"
        ;;
      directory)
        assert_dir "$source_path"
        ;;
      *)
        fail "unknown link type '$type' in $manifest"
        ;;
    esac

    targets+=("$target")
  done < "$manifest"

  if [[ ${#targets[@]} -eq 0 ]]; then
    fail "no managed links found in $manifest"
  fi

  line="$(printf '%s\n' "${targets[@]}" | sort | uniq -d | head -1 || true)"
  [[ -z "$line" ]] || fail "duplicate managed link target in manifest: $line"
}

verify_helper_inventory() {
  local manifest="$REPO/manifests/helpers.txt"
  local helper
  local -a helpers=()
  local required

  assert_file "$manifest"
  while IFS= read -r helper || [[ -n "${helper:-}" ]]; do
    [[ -z "${helper:-}" || "${helper:0:1}" == "#" ]] && continue
    assert_executable "$REPO/bin/$helper"
    helpers+=("$helper")
  done < "$manifest"

  [[ ${#helpers[@]} -gt 0 ]] || fail "no helpers found in $manifest"

  for required in ai ai-start ai-agent ai-context ai-task ai-install ai-copy ai-open; do
    printf '%s\n' "${helpers[@]}" | grep -Fxq "$required" \
      || fail "missing helper '$required' in $manifest"
  done
}

verify_tmux_plugin_manifest() {
  local manifest="$REPO/manifests/tmux/plugins.tsv"
  local name repo_url target_dir _binary_path
  local -a plugins=()

  assert_file "$manifest"
  while IFS=$'\t' read -r name repo_url target_dir _binary_path || [[ -n "${name:-}" ]]; do
    [[ -z "${name:-}" || "${name:0:1}" == "#" ]] && continue
    [[ -n "$repo_url" ]] || fail "missing repo_url for plugin '$name'"
    [[ -n "$target_dir" ]] || fail "missing target_dir for plugin '$name'"
    plugins+=("$name")
  done < "$manifest"

  [[ ${#plugins[@]} -eq 3 ]] || fail "expected 3 tmux plugins, found ${#plugins[@]}"
  assert_dir "$REPO/tmux/conf.d"
}

verify_git_layout() {
  assert_file "$REPO/git/gitconfig"
  assert_file "$REPO/git/gitignore_global"
  assert_dir "$REPO/git/conf.d"
  assert_file "$REPO/git/conf.d/00-core.gitconfig"
  assert_file "$REPO/git/conf.d/10-delta.gitconfig"
  assert_file "$REPO/git/conf.d/20-workflow.gitconfig"
  assert_file "$REPO/git/conf.d/90-aliases.gitconfig"
}

verify_tmux_compatibility_hooks() {
  local copy_mode_conf="$REPO/tmux/conf.d/40-copy-mode.conf"
  local key_conf="$REPO/tmux/conf.d/30-keys.conf"
  local plugin_bootstrap_conf="$REPO/tmux/conf.d/99-plugin-bootstrap.conf"

  assert_file "$copy_mode_conf"
  assert_file "$key_conf"
  assert_file "$plugin_bootstrap_conf"
  grep -Fq "\$HOME/.local/bin/_clipboard_copy" "$copy_mode_conf" \
    || fail "tmux copy mode does not use the managed clipboard adapter"
  grep -Fq "\$HOME/.local/bin/_tmux_help" "$key_conf" \
    || fail "tmux help bindings do not use the managed compatibility helper"
  grep -Fq 'if-shell' "$plugin_bootstrap_conf" \
    || fail "tmux plugin bootstrap is not guarded"
}

verify_package_manifests() {
  local manifest line duplicate

  for manifest in \
    "$REPO/manifests/packages/core-brew.txt" \
    "$REPO/manifests/packages/macos-brew.txt" \
    "$REPO/manifests/packages/macos-cask.txt" \
    "$REPO/manifests/packages/agent-brew.txt" \
    "$REPO/manifests/packages/agent-cask.txt"
  do
    assert_file "$manifest"
    line="$(grep -Ev '^\s*(#|$)' "$manifest" | head -1 || true)"
    [[ -n "$line" ]] || fail "empty package manifest: $manifest"
    duplicate="$(grep -Ev '^\s*(#|$)' "$manifest" | sort | uniq -d | head -1 || true)"
    [[ -z "$duplicate" ]] || fail "duplicate entry '$duplicate' in $manifest"
  done
}

verify_layout_scaffold() {
  assert_file "$REPO/install"
  assert_executable "$REPO/install"
  assert_dir "$REPO/ai"
  assert_dir "$REPO/os"
  assert_dir "$REPO/prompts"
  assert_dir "$REPO/context"
  assert_dir "$REPO/tasks"
  assert_dir "$REPO/.github"
  assert_dir "$REPO/.github/ISSUE_TEMPLATE"
  assert_dir "$REPO/docs/adr"
  assert_dir "$REPO/lib/bootstrap"
  assert_dir "$REPO/lib/dotfiles"
  assert_dir "$REPO/manifests/bootstrap"
  assert_dir "$REPO/manifests/packages"
  assert_dir "$REPO/manifests/tmux"
  assert_dir "$REPO/zsh/modules"
  assert_dir "$REPO/tmux/conf.d"
  assert_file "$REPO/ai/agents.yml"
  assert_file "$REPO/ai/workflows.yml"
  assert_file "$REPO/os/mac.sh"
  assert_file "$REPO/os/linux.sh"
  assert_file "$REPO/os/wsl.sh"
  assert_file "$REPO/prompts/architect.md"
  assert_file "$REPO/prompts/implementer.md"
  assert_file "$REPO/prompts/reviewer.md"
  assert_file "$REPO/prompts/researcher.md"
  assert_file "$REPO/.github/ISSUE_TEMPLATE/feature.yml"
  assert_file "$REPO/.github/ISSUE_TEMPLATE/bug.yml"
  assert_file "$REPO/.github/ISSUE_TEMPLATE/config.yml"
  assert_file "$REPO/.github/pull_request_template.md"
  assert_file "$REPO/context/build-context.sh"
  assert_executable "$REPO/context/build-context.sh"
  assert_file "$REPO/tasks/backlog.md"
  assert_file "$REPO/docs/92-development-workflow.md"
  assert_file "$REPO/docs/adr/README.md"
  assert_file "$REPO/docs/adr/0001-ai-dev-os-delivery-workflow.md"
  assert_file "$REPO/tmux/layout.conf"
}

verify_ai_dev_os_docs() {
  grep -Fq "ai start" "$REPO/README.md" \
    || fail "README.md does not mention ai start"
  grep -Fq "ai start" "$REPO/docs/00-quickstart.md" \
    || fail "docs/00-quickstart.md does not mention ai start"
  grep -Fq ".ai-dev-os/workflows.yml" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not document .ai-dev-os/workflows.yml"
  grep -Fq ".claude/settings.json" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not document vendor-native config boundaries"
}

verify_layout_scaffold
verify_links_manifest
verify_helper_inventory
verify_tmux_plugin_manifest
verify_git_layout
verify_tmux_compatibility_hooks
verify_package_manifests
verify_ai_dev_os_docs

echo "repository structure test passed"
