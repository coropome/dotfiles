#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TEST_HOME="$TMPDIR_ROOT/home"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_git_value() {
  local key="$1"
  local expected="$2"
  local actual

  actual="$(HOME="$TEST_HOME" git config --global --includes --get "$key" || true)"
  [[ "$actual" == "$expected" ]] || fail "$key -> ${actual:-<empty>} (expected $expected)"
}

setup_installed_git_layer() {
  mkdir -p "$TEST_HOME/.config/ditfiles"

  ln -s "$REPO/git/gitconfig" "$TEST_HOME/.config/ditfiles/gitconfig"
  ln -s "$REPO/git/conf.d" "$TEST_HOME/.config/ditfiles/conf.d"
  ln -s "$REPO/git/gitignore_global" "$TEST_HOME/.config/ditfiles/gitignore_global"

  HOME="$TEST_HOME" git config --global --add include.path "$TEST_HOME/.config/ditfiles/gitconfig"
}

setup_installed_git_layer

assert_git_value "core.pager" "delta"
# shellcheck disable=SC2088
assert_git_value "core.excludesfile" "~/.config/ditfiles/gitignore_global"
assert_git_value "merge.conflictstyle" "zdiff3"
assert_git_value "push.autoSetupRemote" "true"
assert_git_value "pull.rebase" "false"
assert_git_value "rebase.autoStash" "true"
assert_git_value "alias.s" "status -sb"
assert_git_value "alias.last" "log -1 --stat"

include_paths="$(HOME="$TEST_HOME" git config --global --get-all include.path)"
[[ "$include_paths" == "$TEST_HOME/.config/ditfiles/gitconfig" ]] \
  || fail "unexpected include.path entries: ${include_paths:-<empty>}"

echo "git config test passed"
