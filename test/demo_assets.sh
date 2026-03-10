#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
GENERATED="$TMPDIR_ROOT/generated"
DEMO="$REPO/demo/sample-project"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_same_file() {
  local left="$1"
  local right="$2"
  cmp -s "$left" "$right" || fail "$left and $right differ"
}

mkdir -p "$GENERATED"
"$REPO/bin/ai-init" --repo "$GENERATED" >/dev/null

assert_same_file "$GENERATED/.ai-dev-os/agents.yml" "$DEMO/.ai-dev-os/agents.yml"
assert_same_file "$GENERATED/.ai-dev-os/workflows.yml" "$DEMO/.ai-dev-os/workflows.yml"
assert_same_file "$GENERATED/.ai-dev-os/README.md" "$DEMO/.ai-dev-os/README.md"
assert_same_file "$GENERATED/prompts/review.prompt.yml" "$DEMO/prompts/review.prompt.yml"

grep -Fq "ai start" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing ai start"
grep -Fq "ai review" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing ai review"
grep -Fq "ai eval review" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing ai eval review"

echo "demo assets test passed"
