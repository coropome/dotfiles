#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TARGET_REPO="$TMPDIR_ROOT/external-repo"
NO_HOSTED_REPO="$TMPDIR_ROOT/no-hosted-repo"
NO_GHA_REPO="$TMPDIR_ROOT/no-github-actions-repo"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

line_number_in_output() {
  local needle="$1"
  local haystack="$2"

  printf '%s\n' "$haystack" | grep -Fnm1 -- "$needle" | cut -d: -f1
}

assert_output_order() {
  local haystack="$1"
  local first="$2"
  local second="$3"
  local first_line
  local second_line

  first_line="$(line_number_in_output "$first" "$haystack")"
  second_line="$(line_number_in_output "$second" "$haystack")"

  [[ -n "$first_line" ]] || fail "missing output line: $first"
  [[ -n "$second_line" ]] || fail "missing output line: $second"
  (( first_line < second_line )) || fail "output does not keep '$first' before '$second'"
}

assert_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "expected file: $path"
}

assert_occurrence_count() {
  local file="$1"
  local needle="$2"
  local expected_count="$3"
  local actual_count

  actual_count="$(grep -Fc -- "$needle" "$file")"
  [[ "$actual_count" == "$expected_count" ]] || fail "$file expected $expected_count occurrences of '$needle' but found $actual_count"
}

git init -q "$TARGET_REPO"
git init -q "$NO_HOSTED_REPO"
git init -q "$NO_GHA_REPO"
mkdir -p "$TARGET_REPO/src"
mkdir -p "$NO_HOSTED_REPO/src" "$NO_GHA_REPO/src"
TARGET_REPO="$(cd "$TARGET_REPO" && pwd -P)"
NO_HOSTED_REPO="$(cd "$NO_HOSTED_REPO" && pwd -P)"
NO_GHA_REPO="$(cd "$NO_GHA_REPO" && pwd -P)"

init_output="$(cd "$TARGET_REPO/src" && "$REPO/bin/ai" init)"

[[ "$init_output" == *"initialized repo: $TARGET_REPO"* ]] || fail "ai init did not report the initialized repo"
[[ "$init_output" == *"next: ai doctor"* ]] || fail "ai init did not print doctor guidance"
[[ "$init_output" == *"next: ai workflows"* ]] || fail "ai init did not print next workflow guidance"
[[ "$init_output" == *"note: ai start uses tmux by default; use ai start --backend stdio when terminal choice should stay flexible"* ]] || fail "ai init did not print backend-aware ai start guidance"
[[ "$init_output" == *"next: ai trust init claude --project"* ]] || fail "ai init did not print trust guidance"
[[ "$init_output" == *"next: ai start"* ]] || fail "ai init did not print ai start guidance"
[[ "$init_output" == *"optional: sed -n '1,160p' .github/workflows/ai-dev-os-pr.yml"* ]] || fail "ai init did not print optional GitHub Actions guidance"
[[ "$init_output" == *"optional: gh workflow run ai-dev-os-hosted-eval.yml"* ]] || fail "ai init did not print optional hosted eval guidance"
assert_output_order "$init_output" "next: ai doctor" "next: ai workflows"
assert_output_order "$init_output" "next: ai workflows" "next: ai agents"
assert_output_order "$init_output" "next: ai agents" "note: ai start uses tmux by default; use ai start --backend stdio when terminal choice should stay flexible"
assert_output_order "$init_output" "note: ai start uses tmux by default; use ai start --backend stdio when terminal choice should stay flexible" "next: ai start"

assert_file "$TARGET_REPO/.ai-dev-os/agents.yml"
assert_file "$TARGET_REPO/.ai-dev-os/workflows.yml"
assert_file "$TARGET_REPO/.ai-dev-os/prompts/implementer.md"
assert_file "$TARGET_REPO/.ai-dev-os/prompts/reviewer.md"
assert_file "$TARGET_REPO/.ai-dev-os/prompts/review.prompt.yml"
assert_file "$TARGET_REPO/.ai-dev-os/README.md"
assert_file "$TARGET_REPO/.github/workflows/ai-dev-os-pr.yml"
assert_file "$TARGET_REPO/.github/workflows/ai-dev-os-hosted-eval.yml"

grep -Fq "local_implementer" "$TARGET_REPO/.ai-dev-os/agents.yml" \
  || fail "ai init did not generate the starter implementer agent"
grep -Fq ".ai-dev-os/prompts/implementer.md" "$TARGET_REPO/.ai-dev-os/agents.yml" \
  || fail "ai init did not wire the starter implementer prompt"
grep -Fq "prompt_handoff: append-system-prompt" "$TARGET_REPO/.ai-dev-os/agents.yml" \
  || fail "ai init did not generate starter handoff metadata"
grep -Fq "local_backup_reviewer" "$TARGET_REPO/.ai-dev-os/agents.yml" \
  || fail "ai init did not generate the fallback reviewer agent"
grep -Fq "default_agent: local_reviewer" "$TARGET_REPO/.ai-dev-os/workflows.yml" \
  || fail "ai init did not generate the starter review workflow"
grep -Fq "fallback_agents: local_backup_reviewer" "$TARGET_REPO/.ai-dev-os/workflows.yml" \
  || fail "ai init did not generate starter workflow fallback"
grep -Fq "ai doctor" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document ai doctor guidance"
grep -Fq "ai-agent --describe --workflow review" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document workflow describe guidance"
grep -Fq "ai trust init claude --project" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document trust init guidance"
grep -Fq "ai start --backend stdio" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document the stdio ai-start option"
grep -Fq "## If Something Fails" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document the failure model"
assert_occurrence_count "$TARGET_REPO/.ai-dev-os/README.md" "## If Something Fails" "1"
grep -Fq "local onboarding problem" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document local onboarding remediation"
grep -Fq "use the current AI Dev OS runtime repo's \`docs/42-github-actions.md\`" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document CI/runtime remediation"
grep -Fq "run \`make doctor\` from the AI Dev OS runtime repo" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document bootstrap remediation"
grep -Fq "## Which Path To Choose" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document the adoption guide"
grep -Fq "local-only first" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document the local-first path"
grep -Fq "default backend は \`tmux\`、lighter path は \`ai start --backend stdio\`" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document backend-aware local-only guidance"
grep -Fq "PR CI next" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document the PR CI path"
grep -Fq "## Optional GitHub Actions Commands" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not separate optional GitHub Actions commands"
grep -Fq ".github/workflows/ai-dev-os-pr.yml" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document the PR starter workflow"
grep -Fq "shared AI Dev OS runtime" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not describe the shared runtime relationship"
grep -Fq "current default runtime source is \`coropome/dotfiles\` at \`main\`" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document the current default runtime source"
grep -Fq "AI_DEV_OS_RUNTIME_REF" "$TARGET_REPO/.ai-dev-os/README.md" \
  || fail "ai init did not document the runtime ref pinning"
[[ "$(<"$TARGET_REPO/.ai-dev-os/README.md")" != *"$REPO/templates/ai-trust/"* ]] \
  || fail "ai init leaked a machine-specific trust template path"
[[ "$(<"$TARGET_REPO/.ai-dev-os/README.md")" != *"/Users/"* ]] \
  || fail "ai init leaked an absolute user path"

printf 'user-owned\n' > "$TARGET_REPO/.ai-dev-os/README.md"
rerun_output="$("$REPO/bin/ai-init" --repo "$TARGET_REPO")"
[[ "$rerun_output" == *"skipped: $TARGET_REPO/.ai-dev-os/README.md (already exists)"* ]] \
  || fail "ai init did not report skipped files on rerun"
[[ "$(cat "$TARGET_REPO/.ai-dev-os/README.md")" == "user-owned" ]] \
  || fail "ai init overwrote an existing README"

unsupported_output="$("$REPO/bin/ai-init" --template unsupported 2>&1 >/dev/null || true)"
[[ "$unsupported_output" == *"unsupported template: unsupported"* ]] \
  || fail "ai init did not reject unsupported templates"

no_hosted_output="$(cd "$NO_HOSTED_REPO/src" && "$REPO/bin/ai-init" --no-hosted-eval)"
[[ "$no_hosted_output" == *"optional: sed -n '1,160p' .github/workflows/ai-dev-os-pr.yml"* ]] \
  || fail "ai init --no-hosted-eval did not keep PR workflow guidance"
[[ "$no_hosted_output" != *"gh workflow run ai-dev-os-hosted-eval.yml"* ]] \
  || fail "ai init --no-hosted-eval still printed hosted eval guidance"
assert_file "$NO_HOSTED_REPO/.github/workflows/ai-dev-os-pr.yml"
[[ ! -e "$NO_HOSTED_REPO/.github/workflows/ai-dev-os-hosted-eval.yml" ]] \
  || fail "ai init --no-hosted-eval still generated hosted eval workflow"
grep -Fq "hosted eval workflow generation was skipped for this run via \`--no-hosted-eval\`" "$NO_HOSTED_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-hosted-eval did not explain skipped hosted eval generation"
grep -Fq "this run skipped hosted eval via \`--no-hosted-eval\`" "$NO_HOSTED_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-hosted-eval did not adapt the adoption guide"
grep -Fq "use this when hosted backend comparison becomes worth the extra credentials and policy surface" "$NO_HOSTED_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-hosted-eval lost hosted eval adoption reasoning"
grep -Fq "## If Something Fails" "$NO_HOSTED_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-hosted-eval lost the failure model"
assert_occurrence_count "$NO_HOSTED_REPO/.ai-dev-os/README.md" "## If Something Fails" "1"
grep -Fq "use the current AI Dev OS runtime repo's \`docs/42-github-actions.md\`" "$NO_HOSTED_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-hosted-eval lost CI/runtime remediation"
grep -Fq ".github/workflows/ai-dev-os-pr.yml" "$NO_HOSTED_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-hosted-eval did not keep PR workflow in README"

no_github_actions_output="$(cd "$NO_GHA_REPO/src" && "$REPO/bin/ai-init" --no-github-actions)"
[[ "$no_github_actions_output" != *"optional: sed -n '1,160p' .github/workflows/ai-dev-os-pr.yml"* ]] \
  || fail "ai init --no-github-actions still printed PR workflow guidance"
[[ "$no_github_actions_output" != *"gh workflow run ai-dev-os-hosted-eval.yml"* ]] \
  || fail "ai init --no-github-actions still printed hosted eval guidance"
[[ ! -e "$NO_GHA_REPO/.github/workflows/ai-dev-os-pr.yml" ]] \
  || fail "ai init --no-github-actions still generated PR workflow"
[[ ! -e "$NO_GHA_REPO/.github/workflows/ai-dev-os-hosted-eval.yml" ]] \
  || fail "ai init --no-github-actions still generated hosted eval workflow"
grep -Fq "GitHub Actions starter generation was skipped for this run via \`--no-github-actions\`." "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions did not explain skipped GitHub Actions generation"
grep -Fq "this run skipped GitHub Actions via \`--no-github-actions\`" "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions did not adapt the adoption guide"
grep -Fq "default backend は \`tmux\`、lighter path は \`ai start --backend stdio\`" "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions did not keep backend-aware local-only guidance"
grep -Fq "use this when you want prompt validation and CLI smoke on pull requests" "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions lost PR CI adoption reasoning"
grep -Fq "use this when hosted backend comparison becomes worth the extra credentials and policy surface" "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions lost hosted eval adoption reasoning"
grep -Fq "## If Something Fails" "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions lost the failure model"
assert_occurrence_count "$NO_GHA_REPO/.ai-dev-os/README.md" "## If Something Fails" "1"
grep -Fq "use \`ai doctor\`" "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions lost local remediation"
grep -Fq "use the current AI Dev OS runtime repo's \`docs/42-github-actions.md\`" "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions lost CI/runtime remediation"
grep -Fq "run \`make doctor\` from the AI Dev OS runtime repo" "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions lost bootstrap remediation"
grep -Fq "runtime pinning later" "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions lost runtime pinning guidance"
grep -Fq ".ai-dev-os/prompts/reviewer.md" "$NO_GHA_REPO/.ai-dev-os/README.md" \
  || fail "ai init --no-github-actions lost local starter file inventory"

echo "ai init test passed"
