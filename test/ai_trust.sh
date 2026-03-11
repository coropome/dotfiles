#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TEST_HOME="$TMPDIR_ROOT/home"
TARGET_REPO="$TMPDIR_ROOT/project"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "expected file: $path"
}

assert_same_file() {
  local actual="$1"
  local expected="$2"
  cmp -s "$actual" "$expected" || fail "$actual did not match $expected"
}

mkdir -p "$TEST_HOME" "$TARGET_REPO"
git init -q "$TARGET_REPO"
TARGET_REPO="$(cd "$TARGET_REPO" && pwd -P)"

claude_init_output="$(
  HOME="$TEST_HOME" "$REPO/bin/ai" trust init claude --project --repo "$TARGET_REPO"
)"
[[ "$claude_init_output" == *"generated: $TARGET_REPO/.claude/settings.json"* ]] \
  || fail "ai trust init did not generate the project claude config"
assert_file "$TARGET_REPO/.claude/settings.json"
assert_same_file "$TARGET_REPO/.claude/settings.json" "$REPO/templates/ai-trust/claude-settings.json"

gemini_project_output="$(
  HOME="$TEST_HOME" "$REPO/bin/ai" trust init gemini --project --repo "$TARGET_REPO"
)"
[[ "$gemini_project_output" == *"generated: $TARGET_REPO/.gemini/settings.json"* ]] \
  || fail "ai trust init did not generate the project gemini config"
assert_same_file "$TARGET_REPO/.gemini/settings.json" "$REPO/templates/ai-trust/gemini-settings.json"

codex_user_output="$(
  HOME="$TEST_HOME" "$REPO/bin/ai" trust init codex --user --repo "$TARGET_REPO"
)"
[[ "$codex_user_output" == *"generated: $TEST_HOME/.codex/config.toml"* ]] \
  || fail "ai trust init did not generate the user codex config"
assert_same_file "$TEST_HOME/.codex/config.toml" "$REPO/templates/ai-trust/codex-config.toml"

printf 'user-owned\n' > "$TEST_HOME/.codex/config.toml"
codex_skip_output="$(
  HOME="$TEST_HOME" "$REPO/bin/ai" trust init codex --user --repo "$TARGET_REPO"
)"
[[ "$codex_skip_output" == *"skipped: $TEST_HOME/.codex/config.toml (already exists)"* ]] \
  || fail "ai trust init did not skip an existing user config"
[[ "$(cat "$TEST_HOME/.codex/config.toml")" == "user-owned" ]] \
  || fail "ai trust init overwrote an existing user config"

codex_apply_output="$(
  HOME="$TEST_HOME" "$REPO/bin/ai" trust apply codex --user --repo "$TARGET_REPO"
)"
[[ "$codex_apply_output" == *"backup: $TEST_HOME/.codex/config.toml.bak."* ]] \
  || fail "ai trust apply did not create a backup"
[[ "$codex_apply_output" == *"applied: $TEST_HOME/.codex/config.toml"* ]] \
  || fail "ai trust apply did not overwrite the target config"
assert_same_file "$TEST_HOME/.codex/config.toml" "$REPO/templates/ai-trust/codex-config.toml"

backup_path="$(find "$TEST_HOME/.codex" -name 'config.toml.bak.*' | head -1)"
[[ -n "$backup_path" ]] || fail "ai trust apply did not leave a backup file"
[[ "$(cat "$backup_path")" == "user-owned" ]] || fail "ai trust apply backup did not preserve the previous contents"

unsupported_scope_output="$(
  HOME="$TEST_HOME" "$REPO/bin/ai" trust init claude --scope invalid --repo "$TARGET_REPO" 2>&1 >/dev/null || true
)"
[[ "$unsupported_scope_output" == *"unsupported trust scope: invalid"* ]] \
  || fail "ai trust did not reject an unsupported scope"

unsupported_vendor_output="$(
  HOME="$TEST_HOME" "$REPO/bin/ai" trust init nope --project --repo "$TARGET_REPO" 2>&1 >/dev/null || true
)"
[[ "$unsupported_vendor_output" == *"unsupported vendor: nope"* ]] \
  || fail "ai trust did not reject an unsupported vendor"

echo "ai trust test passed"
