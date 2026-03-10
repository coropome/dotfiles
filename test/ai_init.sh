#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TARGET_REPO="$TMPDIR_ROOT/external-repo"

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

git init -q "$TARGET_REPO"
mkdir -p "$TARGET_REPO/src"
TARGET_REPO="$(cd "$TARGET_REPO" && pwd -P)"

init_output="$(cd "$TARGET_REPO/src" && "$REPO/bin/ai" init)"

[[ "$init_output" == *"initialized repo: $TARGET_REPO"* ]] || fail "ai init did not report the initialized repo"
[[ "$init_output" == *"next: ai workflows"* ]] || fail "ai init did not print next workflow guidance"

assert_file "$TARGET_REPO/.ai-dev-os/agents.yml"
assert_file "$TARGET_REPO/.ai-dev-os/workflows.yml"
assert_file "$TARGET_REPO/.ai-dev-os/prompts/implementer.md"
assert_file "$TARGET_REPO/.ai-dev-os/prompts/review.prompt.yml"
assert_file "$TARGET_REPO/.ai-dev-os/README.md"

grep -Fq "local_implementer" "$TARGET_REPO/.ai-dev-os/agents.yml" \
  || fail "ai init did not generate the starter implementer agent"
grep -Fq ".ai-dev-os/prompts/implementer.md" "$TARGET_REPO/.ai-dev-os/agents.yml" \
  || fail "ai init did not wire the starter implementer prompt"
grep -Fq "default_agent: local_reviewer" "$TARGET_REPO/.ai-dev-os/workflows.yml" \
  || fail "ai init did not generate the starter review workflow"
grep -Fq "templates/ai-trust/claude-settings.json" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not point to trust templates"

printf 'user-owned\n' > "$TARGET_REPO/.ai-dev-os/README.md"
rerun_output="$("$REPO/bin/ai-init" --repo "$TARGET_REPO")"
[[ "$rerun_output" == *"skipped: $TARGET_REPO/.ai-dev-os/README.md (already exists)"* ]] \
  || fail "ai init did not report skipped files on rerun"
[[ "$(cat "$TARGET_REPO/.ai-dev-os/README.md")" == "user-owned" ]] \
  || fail "ai init overwrote an existing README"

unsupported_output="$("$REPO/bin/ai-init" --template unsupported 2>&1 >/dev/null || true)"
[[ "$unsupported_output" == *"unsupported template: unsupported"* ]] \
  || fail "ai init did not reject unsupported templates"

echo "ai init test passed"
