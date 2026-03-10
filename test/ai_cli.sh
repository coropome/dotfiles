#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TEST_REPO="$TMPDIR_ROOT/project"
STUB_BIN="$TMPDIR_ROOT/bin"
TMUX_LOG="$TMPDIR_ROOT/tmux.log"
OPEN_LOG="$TMPDIR_ROOT/open.log"
COPY_LOG="$TMPDIR_ROOT/copy.log"
CLAUDE_LOG="$TMPDIR_ROOT/claude.log"
CODEX_LOG="$TMPDIR_ROOT/codex.log"
GEMINI_LOG="$TMPDIR_ROOT/gemini.log"
GH_LOG="$TMPDIR_ROOT/gh.log"
TMUX_STATE="$TMPDIR_ROOT/tmux.state"
ORIG_PATH="$PATH"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

setup_project() {
  mkdir -p "$TEST_REPO/.git" "$TEST_REPO/.ai-dev-os" "$STUB_BIN"
  printf "hello\n" > "$TEST_REPO/README.md"
  cat > "$TEST_REPO/.ai-dev-os/agents.yml" <<'EOF'
agents:
  local_reviewer:
    provider: google
    command: gemini
    role: reviewer
    description: Local project override reviewer
EOF
  cat > "$TEST_REPO/.ai-dev-os/workflows.yml" <<'EOF'
workflows:
  native:
    default_agent: local_reviewer
    description: Local project workflow override
EOF
}

setup_stubs() {
  cat > "$STUB_BIN/git" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "-C" ]]; then
  repo="$2"
  shift 2
else
  repo="$PWD"
fi

case "${1:-}" in
  rev-parse)
    case "${2:-}" in
      --show-toplevel)
        printf "%s\n" "$repo"
        ;;
      --abbrev-ref)
        printf "main\n"
        ;;
      *)
        exit 1
        ;;
    esac
    ;;
  rev-list)
    printf "7\n"
    ;;
  log)
    printf "abc123 first\n"
    ;;
  *)
    exit 1
    ;;
esac
EOF

  cat > "$STUB_BIN/tmux" <<EOF
#!/usr/bin/env bash
set -euo pipefail
printf "%s\n" "\$*" >> "$TMUX_LOG"
case "\${1:-}" in
  has-session)
    [[ -f "$TMUX_STATE" ]]
    ;;
  new-session)
    : > "$TMUX_STATE"
    ;;
  kill-session)
    rm -f "$TMUX_STATE"
    ;;
esac
EOF

  cat > "$STUB_BIN/open" <<EOF
#!/usr/bin/env bash
set -euo pipefail
printf "open %s\n" "\$*" > "$OPEN_LOG"
EOF

  cat > "$STUB_BIN/pbcopy" <<EOF
#!/usr/bin/env bash
set -euo pipefail
cat > "$COPY_LOG"
EOF

  cat > "$STUB_BIN/claude" <<EOF
#!/usr/bin/env bash
set -euo pipefail
printf "claude %s\n" "\$*" >> "$CLAUDE_LOG"
EOF

  cat > "$STUB_BIN/codex" <<EOF
#!/usr/bin/env bash
set -euo pipefail
printf "codex %s\n" "\$*" >> "$CODEX_LOG"
EOF

  cat > "$STUB_BIN/gemini" <<EOF
#!/usr/bin/env bash
set -euo pipefail
printf "gemini %s\n" "\$*" >> "$GEMINI_LOG"
EOF

  cat > "$STUB_BIN/gh" <<EOF
#!/usr/bin/env bash
set -euo pipefail
printf "gh %s\n" "\$*" >> "$GH_LOG"
EOF

  chmod +x "$STUB_BIN/git" "$STUB_BIN/tmux" "$STUB_BIN/open" "$STUB_BIN/pbcopy" "$STUB_BIN/claude" "$STUB_BIN/codex" "$STUB_BIN/gemini" "$STUB_BIN/gh"
}

assert_contains() {
  local file="$1"
  local expected="$2"
  grep -Fq "$expected" "$file" || fail "$file missing: $expected"
}

setup_project
setup_stubs

agents_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" agents)"
[[ "$agents_output" == *"claude"* ]] || fail "ai agents did not list claude"
[[ "$agents_output" == *"reviewer"* ]] || fail "ai agents did not list reviewer"

workflows_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" workflows)"
[[ "$workflows_output" == *"code"* ]] || fail "ai workflows did not list code"
[[ "$workflows_output" == *"improve"* ]] || fail "ai workflows did not list improve"

eval_list_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-eval" --list)"
[[ "$eval_list_output" == *"review"* ]] || fail "ai-eval did not list review prompt"

describe_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-agent" --describe claude)"
[[ "$describe_output" == *"project_config: .claude/settings.json"* ]] || fail "ai-agent describe missing project config"
[[ "$describe_output" == *"mcp_config: .claude/settings.json"* ]] || fail "ai-agent describe missing mcp config"
[[ "$describe_output" == *"prompt_file: prompts/implementer.md"* ]] || fail "ai-agent describe missing prompt file"
[[ "$describe_output" == *"trust_template: templates/ai-trust/claude-settings.json"* ]] || fail "ai-agent describe missing trust template"

reviewer_describe_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-agent" --describe reviewer)"
[[ "$reviewer_describe_output" == *"prompt_file: prompts/reviewer.md"* ]] || fail "reviewer role metadata did not resolve"

task_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" task)"
[[ "$task_output" == *"AI Dev OS Backlog"* ]] || fail "ai task did not print the backlog"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-context" --repo "$TEST_REPO" >/dev/null
[[ -f "$TEST_REPO/.context/summary.md" ]] || fail "ai-context did not create summary.md"
assert_contains "$TEST_REPO/.context/summary.md" "branch: main"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-open" "https://example.com"
assert_contains "$OPEN_LOG" "open https://example.com"

printf "copied" | PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-copy"
[[ "$(cat "$COPY_LOG")" == "copied" ]] || fail "ai-copy did not forward stdin"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-start" --repo "$TEST_REPO" >/dev/null || true
[[ -f "$TEST_REPO/.context/summary.md" ]] || fail "ai-start did not refresh summary.md"
assert_contains "$TMUX_LOG" "new-session -d -s ai-dev-os-project -n workspace -c $TEST_REPO"
assert_contains "$TMUX_LOG" "split-window -v -t ai-dev-os-project:workspace.1 -c $TEST_REPO"
assert_contains "$TMUX_LOG" "send-keys -t ai-dev-os-project:workspace.2 $REPO/bin/ai-context --repo $TEST_REPO --show"
assert_contains "$TMUX_LOG" "select-layout -t ai-dev-os-project:workspace tiled"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" stop --repo "$TEST_REPO" >/dev/null
assert_contains "$TMUX_LOG" "kill-session -t ai-dev-os-project"

rm -f "$STUB_BIN/tmux"
start_failure="$(
  PATH="$STUB_BIN:/usr/bin:/bin" "$REPO/bin/ai-start" --repo "$TEST_REPO" 2>&1 >/dev/null || true
)"
[[ "$start_failure" == *"missing dependency: tmux"* ]] || fail "ai-start did not explain missing tmux"
[[ "$start_failure" == *"run: make install"* ]] || fail "ai-start did not show tmux remediation"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" code >/dev/null
assert_contains "$CLAUDE_LOG" "claude "

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" review >/dev/null
assert_contains "$CODEX_LOG" "codex "

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" improve --latest-trends >/dev/null
assert_contains "$CODEX_LOG" "codex --latest-trends"

eval_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" eval review)"
[[ "$eval_output" == *"mode: local-structure-check"* ]] || fail "ai eval did not run the local evaluation flow"
[[ "$eval_output" == *"hosted_hint: gh models eval --file"* ]] || fail "ai eval did not print the hosted fallback hint"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" eval --hosted review >/dev/null
assert_contains "$GH_LOG" "gh models eval --file $REPO/prompts/review.prompt.yml"

rm -f "$STUB_BIN/gh"
hosted_failure="$(
  PATH="$STUB_BIN:/usr/bin:/bin" "$REPO/bin/ai" eval --hosted review 2>&1 >/dev/null || true
)"
[[ "$hosted_failure" == *"hosted eval requires GitHub CLI"* ]] || fail "ai eval did not explain missing hosted eval backend"

local_workflows_output="$(cd "$TEST_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" workflows)"
[[ "$local_workflows_output" == *"native"* ]] || fail "local workflows override did not load"

local_describe_output="$(cd "$TEST_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-agent" --describe local_reviewer)"
[[ "$local_describe_output" == *"command: gemini"* ]] || fail "local agent override did not describe gemini"

(cd "$TEST_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" native --project-scope >/dev/null)
assert_contains "$GEMINI_LOG" "gemini --project-scope"

echo "ai cli test passed"
