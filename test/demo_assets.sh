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

first_line_number() {
  local needle="$1"
  local file="$2"

  grep -Fnm1 -- "$needle" "$file" | cut -d: -f1
}

assert_in_order() {
  local file="$1"
  local first="$2"
  local second="$3"
  local first_line
  local second_line

  first_line="$(first_line_number "$first" "$file")"
  second_line="$(first_line_number "$second" "$file")"

  [[ -n "$first_line" ]] || fail "$file missing: $first"
  [[ -n "$second_line" ]] || fail "$file missing: $second"
  (( first_line < second_line )) || fail "$file does not keep '$first' before '$second'"
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
assert_same_file "$GENERATED/.ai-dev-os/prompts/implementer.md" "$DEMO/.ai-dev-os/prompts/implementer.md"
assert_same_file "$GENERATED/.ai-dev-os/prompts/reviewer.md" "$DEMO/.ai-dev-os/prompts/reviewer.md"
assert_same_file "$GENERATED/.ai-dev-os/prompts/review.prompt.yml" "$DEMO/.ai-dev-os/prompts/review.prompt.yml"
assert_same_file "$GENERATED/.github/workflows/ai-dev-os-pr.yml" "$DEMO/.github/workflows/ai-dev-os-pr.yml"
assert_same_file "$GENERATED/.github/workflows/ai-dev-os-hosted-eval.yml" "$DEMO/.github/workflows/ai-dev-os-hosted-eval.yml"

grep -Fq "Stage 1: inspect the local starter first" "$REPO/demo/sample-project/README.md" \
  || fail "demo README missing stage 1 guidance"
grep -Fq "ai doctor" "$REPO/demo/sample-project/README.md" \
  || fail "demo README missing ai doctor"
grep -Fq "ai workflows" "$REPO/demo/sample-project/README.md" \
  || fail "demo README missing ai workflows"
grep -Fq "ai start --repo demo/sample-project" "$REPO/demo/sample-project/README.md" \
  || fail "demo README missing ai start"
grep -Fq "current default backend is \`tmux\`" "$REPO/demo/sample-project/README.md" \
  || fail "demo README missing the tmux-default backend note"
grep -Fq "ai start --repo demo/sample-project --backend stdio" "$REPO/demo/sample-project/README.md" \
  || fail "demo README missing the stdio ai-start alternative"
grep -Fq "docs/42-github-actions.md" "$REPO/demo/sample-project/README.md" \
  || fail "demo README missing CI/runtime guidance"
grep -Fq "make doctor" "$REPO/demo/sample-project/README.md" \
  || fail "demo README missing bootstrap guidance"
assert_in_order "$REPO/demo/sample-project/README.md" "## Stage 1: inspect the local starter first" "## Stage 2: inspect the local workflow surface"
assert_in_order "$REPO/demo/sample-project/README.md" "## Stage 2: inspect the local workflow surface" "## Stage 3: start the workspace"
assert_in_order "$REPO/demo/sample-project/README.md" "## Stage 3: start the workspace" "## Stage 4: optional prompt check"
assert_in_order "$REPO/demo/sample-project/README.md" "ai doctor" "ai workflows"
assert_in_order "$REPO/demo/sample-project/README.md" "ai workflows" "ai start --repo demo/sample-project"
assert_in_order "$REPO/demo/sample-project/README.md" "ai start --repo demo/sample-project" "current default backend is \`tmux\`"
assert_in_order "$REPO/demo/sample-project/README.md" "current default backend is \`tmux\`" "ai start --repo demo/sample-project --backend stdio"

grep -Fq "ai start" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing ai start"
grep -Fq "ai start --repo \"\$(pwd)\" --backend stdio" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing stdio backend guidance"
grep -Fq "ai review" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing ai review"
grep -Fq "ai eval review" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing ai eval review"
grep -Fq "ai doctor" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing ai doctor"
grep -Fq "ai-agent --describe --workflow review" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing workflow describe inspection"
grep -Fq "sed -n '1,200p' README.md" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing demo README inspection"
grep -Fq "sed -n '1,200p' .ai-dev-os/README.md" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing starter README inspection"
grep -Fq "Stage 1: local onboarding" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing stage 1 guidance"
grep -Fq "Stage 2: local workflow" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing stage 2 guidance"
grep -Fq "Stage 3: local path が見えたあとに optional な prompt check" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing stage 3 guidance"
grep -Fq "local-only / PR CI / hosted eval" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing adoption model guidance"
grep -Fq "docs/42-github-actions.md" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing CI guidance link"
grep -Fq "bootstrap failure は \`make doctor\`" "$REPO/docs/05-demo-walkthrough.md" \
  || fail "walkthrough missing failure model guidance"
assert_in_order "$REPO/docs/05-demo-walkthrough.md" "sed -n '1,200p' README.md" "sed -n '1,200p' .ai-dev-os/README.md"
assert_in_order "$REPO/docs/05-demo-walkthrough.md" "sed -n '1,200p' .ai-dev-os/README.md" "ai doctor"
assert_in_order "$REPO/docs/05-demo-walkthrough.md" "ai doctor" "ai workflows"
assert_in_order "$REPO/docs/05-demo-walkthrough.md" "ai workflows" "ai-agent --describe --workflow review"
assert_in_order "$REPO/docs/05-demo-walkthrough.md" "ai-agent --describe --workflow review" "ai start --repo \"\$(pwd)\""
assert_in_order "$REPO/docs/05-demo-walkthrough.md" "ai start --repo \"\$(pwd)\"" "ai eval review"

echo "demo assets test passed"
