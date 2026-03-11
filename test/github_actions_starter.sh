#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TARGET_REPO="$TMPDIR_ROOT/project"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_contains() {
  local path="$1"
  local expected="$2"
  grep -Fq "$expected" "$path" || fail "$path missing: $expected"
}

git init -q "$TARGET_REPO"
TARGET_REPO="$(cd "$TARGET_REPO" && pwd -P)"

"$REPO/bin/ai-init" --repo "$TARGET_REPO" >/dev/null

pr_workflow="$TARGET_REPO/.github/workflows/ai-dev-os-pr.yml"
hosted_workflow="$TARGET_REPO/.github/workflows/ai-dev-os-hosted-eval.yml"

[[ -f "$pr_workflow" ]] || fail "missing PR starter workflow"
[[ -f "$hosted_workflow" ]] || fail "missing hosted eval starter workflow"

assert_contains "$pr_workflow" "pull_request:"
assert_contains "$pr_workflow" "AI_DEV_OS_RUNTIME_REPOSITORY: coropome/dotfiles"
assert_contains "$pr_workflow" "AI_DEV_OS_RUNTIME_REF: main"
assert_contains "$pr_workflow" "repository: \${{ env.AI_DEV_OS_RUNTIME_REPOSITORY }}"
assert_contains "$pr_workflow" "ref: \${{ env.AI_DEV_OS_RUNTIME_REF }}"
assert_contains "$pr_workflow" "\"\$GITHUB_WORKSPACE/ai-dev-os/bin/ai-eval\" --list"
assert_contains "$pr_workflow" "\"\$GITHUB_WORKSPACE/ai-dev-os/bin/ai-init\" --repo \"\$smoke_repo\""
assert_contains "$pr_workflow" "\"\$GITHUB_WORKSPACE/ai-dev-os/bin/ai-agent\" --describe --workflow review"

assert_contains "$hosted_workflow" "workflow_dispatch:"
assert_contains "$hosted_workflow" "AI_DEV_OS_RUNTIME_REF: main"
assert_contains "$hosted_workflow" "ref: \${{ env.AI_DEV_OS_RUNTIME_REF }}"
assert_contains "$hosted_workflow" "GH_TOKEN: \${{ secrets.GH_TOKEN }}"
assert_contains "$hosted_workflow" "\"\$GITHUB_WORKSPACE/ai-dev-os/bin/ai-eval\" --hosted \"\$prompt_name\""

echo "github actions starter test passed"
