#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TEST_REPO="$TMPDIR_ROOT/project"
GLOBAL_REPO="$TMPDIR_ROOT/global-project"
INIT_REPO="$TMPDIR_ROOT/init-project"
STUB_BIN="$TMPDIR_ROOT/bin"
PENDING_BACKLOG="$TMPDIR_ROOT/pending-backlog.md"
NO_PENDING_BACKLOG="$TMPDIR_ROOT/no-pending-backlog.md"
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
  mkdir -p "$TEST_REPO/.git" "$TEST_REPO/.ai-dev-os/prompts" "$GLOBAL_REPO/.git" "$INIT_REPO" "$STUB_BIN"
  printf "hello\n" > "$TEST_REPO/README.md"
  printf "global\n" > "$GLOBAL_REPO/README.md"
  cat > "$TEST_REPO/.ai-dev-os/prompts/local-reviewer.md" <<'EOF'
# Local Reviewer

Review the active repository override.
EOF
  cat > "$TEST_REPO/.ai-dev-os/agents.yml" <<'EOF'
agents:
  local_reviewer:
    provider: google
    command: gemini
    role: reviewer
    description: Local project override reviewer
    prompt_file: .ai-dev-os/prompts/local-reviewer.md
    prompt_handoff: prompt
    context_handoff: prompt
  broken_native:
    provider: google
    command: gemini
    role: reviewer
    description: Broken project workflow
    prompt_file: .ai-dev-os/prompts/missing.md
    prompt_handoff: prompt
    context_handoff: prompt
  missing_native:
    provider: openai
    command: missing-codex
    role: reviewer
    description: Missing backend workflow
    prompt_file: .ai-dev-os/prompts/local-reviewer.md
    prompt_handoff: prompt
    context_handoff: prompt
EOF
  cat > "$TEST_REPO/.ai-dev-os/workflows.yml" <<'EOF'
workflows:
  native:
    default_agent: local_reviewer
    description: Local project workflow override
  broken:
    default_agent: broken_native
    description: Broken project workflow override
  broken_fallback:
    default_agent: broken_native
    fallback_agents: local_reviewer
    description: Broken primary prompt with viable fallback
  unusable:
    default_agent: broken_native
    fallback_agents: missing_native
    description: No viable workflow candidates
EOF

  cat > "$PENDING_BACKLOG" <<'EOF'
# AI Dev OS Backlog

Tracking note:
- `Tracking: #<issue> (closed)` means the task landed in `main` and stays here as historical context.
- `Tracking: pending` means the task has not been turned into a GitHub Issue yet.

## Task 99

Title: Example pending task
Tracking: pending

Problem:
Pending example.

Expected Impact:
Pending example.

## Task 100

Title: Example closed task
Tracking: #100 (closed)

Problem:
Closed example.

Expected Impact:
Closed example.
EOF

  cat > "$NO_PENDING_BACKLOG" <<'EOF'
# AI Dev OS Backlog

Tracking note:
- `Tracking: #<issue> (closed)` means the task landed in `main` and stays here as historical context.
- `Tracking: pending` means the task has not been turned into a GitHub Issue yet.

## Task 101

Title: Example closed task
Tracking: #101 (closed)

Problem:
Closed example.

Expected Impact:
Closed example.
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
  grep -Fq -- "$expected" "$file" || fail "$file missing: $expected"
}

setup_project
setup_stubs

help_output="$(cd "$GLOBAL_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" --help)"
[[ "$help_output" == *"First Steps:"* ]] || fail "ai help did not print the first-steps section"
[[ "$help_output" == *"runtime repo  ai doctor -> ai start"* ]] || fail "ai help did not print the runtime repo path"
[[ "$help_output" == *"starter repo  ai init -> ai doctor -> ai workflows -> ai start"* ]] || fail "ai help did not print the starter repo path"
[[ "$help_output" == *"deeper use    ai code | ai review | ai task | ai agents"* ]] || fail "ai help did not print the deeper command path"
[[ "$help_output" == *"Workflow Shortcuts:"* ]] || fail "ai help did not print workflow shortcuts"
[[ "$help_output" == *"code"* ]] || fail "ai help did not list code workflow"
[[ "$help_output" == *"[candidates: implementer -> codex -> gemini]"* ]] || fail "ai help did not include workflow candidate metadata"
[[ "$help_output" == *".ai-dev-os/workflows.yml"* ]] || fail "ai help did not mention project-local overrides"
[[ "$help_output" == *"doctor        inspect workflow resolution and agent readiness"* ]] || fail "ai help did not list the doctor command"
[[ "$help_output" == *"task          summarize pending backlog work for refinement and print the backlog"* ]] || fail "ai help did not list the updated task command"
[[ "$help_output" == *"trust         generate or apply vendor-native trust config"* ]] || fail "ai help did not list the trust command"
help_first_steps="${help_output%%Workflow Shortcuts:*}"
[[ "$help_first_steps" == *"starter repo  ai init -> ai doctor -> ai workflows -> ai start"* ]] || fail "ai help did not keep starter guidance before workflow shortcuts"
[[ "$help_first_steps" == *"deeper use    ai code | ai review | ai task | ai agents"* ]] || fail "ai help did not keep deeper commands in first steps"
runtime_help_line="$(printf '%s\n' "$help_output" | rg '^  runtime repo' -n)"
starter_help_line="$(printf '%s\n' "$help_output" | rg '^  starter repo' -n)"
deeper_help_line="$(printf '%s\n' "$help_output" | rg '^  deeper use' -n)"
[[ -n "$runtime_help_line" && -n "$starter_help_line" && -n "$deeper_help_line" ]] || fail "ai help did not print ordered first-step lines"
[[ "${runtime_help_line%%:*}" -lt "${starter_help_line%%:*}" ]] || fail "ai help did not print runtime guidance before starter guidance"
[[ "${starter_help_line%%:*}" -lt "${deeper_help_line%%:*}" ]] || fail "ai help did not print starter guidance before deeper commands"

agents_output="$(cd "$GLOBAL_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" agents)"
[[ "$agents_output" == *"agent | provider | role | command | description"* ]] || fail "ai agents did not print the metadata header"
[[ "$agents_output" == *"claude | anthropic | coding-agent | claude | Claude Code interactive coding agent"* ]] || fail "ai agents did not list claude metadata"
[[ "$agents_output" == *"reviewer | openai | reviewer | codex | Reviews code for regressions and risks"* ]] || fail "ai agents did not list reviewer metadata"

workflows_output="$(cd "$GLOBAL_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" workflows)"
[[ "$workflows_output" == *"workflow | candidates | description"* ]] || fail "ai workflows did not print the metadata header"
[[ "$workflows_output" == *"code | implementer -> codex -> gemini | Launch the primary implementation agent"* ]] || fail "ai workflows did not list code candidate metadata"
[[ "$workflows_output" == *"improve | researcher -> codex -> claude | Explore new tools, prompts, and workflow improvements"* ]] || fail "ai workflows did not list improve candidate metadata"
[[ "$workflows_output" == *"Next Steps:"* ]] || fail "ai workflows did not print next-step guidance"
[[ "$workflows_output" == *"inspect a workflow: ai-agent --describe --workflow <name>"* ]] || fail "ai workflows did not explain workflow inspection"
[[ "$workflows_output" == *"then continue the beginner path: ai start"* ]] || fail "ai workflows did not point back to ai start"
workflows_source_line="$(printf '%s\n' "$workflows_output" | rg '^source:' -n)"
workflows_inspect_line="$(printf '%s\n' "$workflows_output" | rg '^  - inspect a workflow:' -n)"
workflows_start_line="$(printf '%s\n' "$workflows_output" | rg '^  - then continue the beginner path:' -n)"
[[ -n "$workflows_source_line" && -n "$workflows_inspect_line" && -n "$workflows_start_line" ]] || fail "ai workflows did not print ordered next-step guidance"
[[ "${workflows_source_line%%:*}" -lt "${workflows_inspect_line%%:*}" ]] || fail "ai workflows did not print next-step guidance after the table"
[[ "${workflows_inspect_line%%:*}" -lt "${workflows_start_line%%:*}" ]] || fail "ai workflows did not keep inspection before ai start"

agent_help_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-agent" --help)"
[[ "$agent_help_output" == *"--describe --workflow review"* ]] || fail "ai-agent help did not include workflow describe usage"

trust_help_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" trust --help)"
[[ "$trust_help_output" == *"usage: ai-trust <init|apply>"* ]] || fail "ai trust help did not print usage"
[[ "$trust_help_output" == *"ai trust init claude --project"* ]] || fail "ai trust help did not include examples"

eval_list_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-eval" --list)"
[[ "$eval_list_output" == *"review"* ]] || fail "ai-eval did not list review prompt"

init_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" init --repo "$INIT_REPO")"
[[ "$init_output" == *".ai-dev-os/agents.yml"* ]] || fail "ai init did not generate agents.yml"
[[ "$init_output" == *"next: ai doctor"* ]] || fail "ai init did not print doctor guidance"
[[ -f "$INIT_REPO/.ai-dev-os/agents.yml" ]] || fail "ai init did not create .ai-dev-os/agents.yml"
[[ -f "$INIT_REPO/.ai-dev-os/workflows.yml" ]] || fail "ai init did not create .ai-dev-os/workflows.yml"
[[ -f "$INIT_REPO/.ai-dev-os/prompts/review.prompt.yml" ]] || fail "ai init did not create starter prompt artifact"
[[ -f "$INIT_REPO/.ai-dev-os/prompts/implementer.md" ]] || fail "ai init did not create the starter implementer prompt"
[[ -f "$INIT_REPO/.ai-dev-os/prompts/reviewer.md" ]] || fail "ai init did not create the starter reviewer prompt"
[[ -f "$INIT_REPO/.ai-dev-os/README.md" ]] || fail "ai init did not create trust-template pointer doc"
assert_contains "$INIT_REPO/.ai-dev-os/README.md" "ai doctor"
assert_contains "$INIT_REPO/.ai-dev-os/README.md" "ai trust init claude --project"
assert_contains "$INIT_REPO/.ai-dev-os/README.md" "## Optional GitHub Actions Commands"
[[ "$(<"$INIT_REPO/.ai-dev-os/README.md")" != *"/Users/"* ]] || fail "ai init leaked an absolute path into the starter README"

describe_output="$(cd "$GLOBAL_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-agent" --describe claude)"
[[ "$describe_output" == *"project_config: .claude/settings.json"* ]] || fail "ai-agent describe missing project config"
[[ "$describe_output" == *"mcp_config: .claude/settings.json"* ]] || fail "ai-agent describe missing mcp config"
[[ "$describe_output" == *"prompt_file: prompts/implementer.md"* ]] || fail "ai-agent describe missing prompt file"
[[ "$describe_output" == *"launch_behavior: prompt->append-system-prompt, context->prompt"* ]] || fail "ai-agent describe missing launch behavior"
[[ "$describe_output" == *"resolved_prompt_file: $REPO/prompts/implementer.md"* ]] || fail "ai-agent describe missing resolved prompt file"
[[ "$describe_output" == *"resolved_context_file: $GLOBAL_REPO/.context/summary.md"* ]] || fail "ai-agent describe missing resolved context file"
[[ "$describe_output" == *"trust_template: templates/ai-trust/claude-settings.json"* ]] || fail "ai-agent describe missing trust template"

reviewer_describe_output="$(cd "$GLOBAL_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-agent" --describe reviewer)"
[[ "$reviewer_describe_output" == *"prompt_file: prompts/reviewer.md"* ]] || fail "reviewer role metadata did not resolve"
[[ "$reviewer_describe_output" == *"launch_behavior: prompt->prompt, context->prompt"* ]] || fail "reviewer describe missing prompt/context behavior"

workflow_describe_output="$(cd "$GLOBAL_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-agent" --describe --workflow review)"
[[ "$workflow_describe_output" == *"workflow: review"* ]] || fail "ai-agent did not describe the resolved workflow"
[[ "$workflow_describe_output" == *"fallback_agents: claude, gemini"* ]] || fail "ai-agent describe missing fallback agents"
[[ "$workflow_describe_output" == *"resolution_candidates: reviewer, claude, gemini"* ]] || fail "ai-agent describe missing resolution candidates"
[[ "$workflow_describe_output" == *"agents_config: $REPO/ai/agents.yml"* ]] || fail "ai-agent did not report the resolved agent config"

task_output="$(cd "$GLOBAL_REPO" && AI_TASK_BACKLOG_FILE="$PENDING_BACKLOG" PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" task)"
[[ "$task_output" == *"AI Dev OS Pending Tasks"* ]] || fail "ai task did not print the pending summary header"
[[ "$task_output" == *"Pending count: 1"* ]] || fail "ai task did not print the pending task count"
[[ "$task_output" == *"- Task 99: Example pending task"* ]] || fail "ai task did not summarize pending tasks"
[[ "$task_output" == *"AI Dev OS Backlog"* ]] || fail "ai task did not print the backlog body"
task_summary="${task_output%%# AI Dev OS Backlog*}"
[[ "$task_summary" == *"- Task 99: Example pending task"* ]] || fail "ai task summary did not include the pending task before the backlog body"
[[ "$task_summary" != *"Example closed task"* ]] || fail "ai task summary included a closed task"
[[ "$task_output" == *"Title: Example closed task"* ]] || fail "ai task did not preserve the closed task in the backlog body"
[[ "$task_output" == *"Tracking: #100 (closed)"* ]] || fail "ai task did not preserve closed-task tracking in the backlog body"

no_pending_task_output="$(AI_TASK_BACKLOG_FILE="$NO_PENDING_BACKLOG" PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-task")"
[[ "$no_pending_task_output" == *"AI Dev OS Pending Tasks"* ]] || fail "ai-task did not print the no-pending summary header"
[[ "$no_pending_task_output" == *"Pending count: 0"* ]] || fail "ai-task did not print the zero pending count"
[[ "$no_pending_task_output" == *"- none"* ]] || fail "ai-task did not explain the no-pending case"
[[ "$no_pending_task_output" == *"AI Dev OS Backlog"* ]] || fail "ai-task did not preserve the backlog output in the no-pending case"
no_pending_summary="${no_pending_task_output%%# AI Dev OS Backlog*}"
[[ "$no_pending_summary" == *"- none"* ]] || fail "ai-task did not keep the no-pending marker before the backlog body"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-context" --repo "$TEST_REPO" >/dev/null
[[ -f "$TEST_REPO/.context/summary.md" ]] || fail "ai-context did not create summary.md"
assert_contains "$TEST_REPO/.context/summary.md" "branch: main"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-open" "https://example.com"
assert_contains "$OPEN_LOG" "open https://example.com"

printf "copied" | PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-copy"
[[ "$(cat "$COPY_LOG")" == "copied" ]] || fail "ai-copy did not forward stdin"

start_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-start" --repo "$TEST_REPO")"
[[ -f "$TEST_REPO/.context/summary.md" ]] || fail "ai-start did not refresh summary.md"
[[ "$start_output" == *"AI Dev OS workspace ready:"* ]] || fail "ai-start did not print the workspace-ready line"
[[ "$start_output" == *"Backend: tmux"* ]] || fail "ai-start did not report the tmux backend"
[[ "$start_output" == *"Next: ai doctor | ai workflows"* ]] || fail "ai-start did not print the beginner guidance"
[[ "$start_output" == *"Then: ai code | ai review | ai task | ai agents"* ]] || fail "ai-start did not keep the deeper commands visible"
start_next_line="$(printf '%s\n' "$start_output" | rg '^Next:' -n)"
start_then_line="$(printf '%s\n' "$start_output" | rg '^Then:' -n)"
[[ -n "$start_next_line" && -n "$start_then_line" ]] || fail "ai-start did not print ordered guidance lines"
[[ "${start_next_line%%:*}" -lt "${start_then_line%%:*}" ]] || fail "ai-start did not print beginner guidance before deeper commands"
assert_contains "$TMUX_LOG" "new-session -d -s ai-dev-os-project -n workspace -c $TEST_REPO"
assert_contains "$TMUX_LOG" "split-window -v -t ai-dev-os-project:workspace.1 -c $TEST_REPO"
assert_contains "$TMUX_LOG" "send-keys -t ai-dev-os-project:workspace.2 $REPO/bin/ai-context --repo $TEST_REPO --show"
assert_contains "$TMUX_LOG" "select-layout -t ai-dev-os-project:workspace tiled"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" stop --repo "$TEST_REPO" >/dev/null
assert_contains "$TMUX_LOG" "kill-session -t ai-dev-os-project"

tmux_log_before_stdio="$(cat "$TMUX_LOG")"
rm -f "$STUB_BIN/tmux"
stdio_output="$(PATH="$STUB_BIN:/usr/bin:/bin" "$REPO/bin/ai-start" --repo "$TEST_REPO" --backend stdio)"
[[ "$stdio_output" == *"AI Dev OS workspace ready: stdio"* ]] || fail "ai-start stdio backend did not print the stdio workspace label"
[[ "$stdio_output" == *"Backend: stdio"* ]] || fail "ai-start stdio backend did not report the stdio backend"
[[ "$stdio_output" == *"Next: ai doctor | ai workflows"* ]] || fail "ai-start stdio backend did not keep the beginner guidance"
[[ "$(cat "$TMUX_LOG")" == "$tmux_log_before_stdio" ]] || fail "ai-start stdio backend unexpectedly touched tmux"
PATH="$STUB_BIN:/usr/bin:/bin" "$REPO/bin/ai-start" --repo "$TEST_REPO" --backend stdio --stop >/dev/null

start_failure="$(
  PATH="$STUB_BIN:/usr/bin:/bin" "$REPO/bin/ai-start" --repo "$TEST_REPO" 2>&1 >/dev/null || true
)"
[[ "$start_failure" == *"missing dependency: tmux"* ]] || fail "ai-start did not explain missing tmux"
[[ "$start_failure" == *"run: make install (from the AI Dev OS runtime repo)"* ]] || fail "ai-start did not show tmux remediation"

(
  cd "$GLOBAL_REPO"
  PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" code >/dev/null
)
assert_contains "$CLAUDE_LOG" "--append-system-prompt Workflow prompt"
assert_contains "$CLAUDE_LOG" "source: $REPO/prompts/implementer.md"
assert_contains "$CLAUDE_LOG" "source: $GLOBAL_REPO/.context/summary.md"

(
  cd "$GLOBAL_REPO"
  PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" review >/dev/null
)
assert_contains "$CODEX_LOG" "source: $REPO/prompts/reviewer.md"
assert_contains "$CODEX_LOG" "source: $GLOBAL_REPO/.context/summary.md"

rm -f "$STUB_BIN/codex"
review_fallback_output="$(
  cd "$GLOBAL_REPO" && PATH="$STUB_BIN:/usr/bin:/bin" "$REPO/bin/ai" review --fallback-check 2>&1 >/dev/null
)"
[[ "$review_fallback_output" == *"workflow review: falling back from reviewer to claude"* ]] || fail "ai review did not report workflow fallback"
assert_contains "$CLAUDE_LOG" "claude --append-system-prompt Workflow prompt"
assert_contains "$CLAUDE_LOG" "--fallback-check"
assert_contains "$CLAUDE_LOG" "source: $REPO/prompts/implementer.md"
cat > "$STUB_BIN/codex" <<EOF
#!/usr/bin/env bash
set -euo pipefail
printf "codex %s\n" "\$*" >> "$CODEX_LOG"
EOF
chmod +x "$STUB_BIN/codex"

(
  cd "$GLOBAL_REPO"
  PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" improve --latest-trends >/dev/null
)
assert_contains "$GEMINI_LOG" "gemini --latest-trends"
assert_contains "$GEMINI_LOG" "source: $REPO/prompts/researcher.md"
assert_contains "$GEMINI_LOG" "source: $GLOBAL_REPO/.context/summary.md"

eval_output="$(cd "$GLOBAL_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" eval review)"
[[ "$eval_output" == *"mode: local-structure-check"* ]] || fail "ai eval did not run the local evaluation flow"
[[ "$eval_output" == *"hosted_hint: gh models eval --file"* ]] || fail "ai eval did not print the hosted fallback hint"

(cd "$GLOBAL_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" eval --hosted review >/dev/null)
assert_contains "$GH_LOG" "gh models eval --file $REPO/prompts/review.prompt.yml"

rm -f "$STUB_BIN/gh"
hosted_failure="$(
  cd "$GLOBAL_REPO" && PATH="$STUB_BIN:/usr/bin:/bin" "$REPO/bin/ai" eval --hosted review 2>&1 >/dev/null || true
)"
[[ "$hosted_failure" == *"hosted eval requires GitHub CLI"* ]] || fail "ai eval did not explain missing hosted eval backend"

local_workflows_output="$(cd "$TEST_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" workflows)"
[[ "$local_workflows_output" == *"native | local_reviewer | Local project workflow override"* ]] || fail "local workflows override did not load"
[[ "$local_workflows_output" == *"source: $TEST_REPO/.ai-dev-os/workflows.yml"* ]] || fail "local workflows output did not report the override source"
[[ "$local_workflows_output" == *"inspect a workflow: ai-agent --describe --workflow <name>"* ]] || fail "local workflows output did not keep next-step guidance"

local_describe_output="$(cd "$TEST_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-agent" --describe local_reviewer)"
[[ "$local_describe_output" == *"command: gemini"* ]] || fail "local agent override did not describe gemini"
[[ "$local_describe_output" == *"resolved_prompt_file: $TEST_REPO/.ai-dev-os/prompts/local-reviewer.md"* ]] || fail "local agent override did not resolve project-local prompt"

(cd "$TEST_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" native --project-scope >/dev/null)
assert_contains "$GEMINI_LOG" "gemini --project-scope Workflow prompt"
assert_contains "$GEMINI_LOG" "source: $TEST_REPO/.ai-dev-os/prompts/local-reviewer.md"

broken_native_failure="$(
  cd "$TEST_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" broken 2>&1 >/dev/null || true
)"
[[ "$broken_native_failure" == *"missing prompt file for broken_native: $TEST_REPO/.ai-dev-os/prompts/missing.md"* ]] || fail "broken workflow did not report the missing prompt file"
[[ "$broken_native_failure" == *"create the prompt file or update prompt_file/prompt_handoff for broken_native"* ]] || fail "broken workflow did not include prompt remediation"
[[ "$broken_native_failure" == *"run: ai doctor"* ]] || fail "broken workflow did not include doctor remediation"

broken_fallback_output="$(
  cd "$TEST_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" broken_fallback --local-fallback 2>&1 >/dev/null
)"
[[ "$broken_fallback_output" == *"workflow broken_fallback: falling back from broken_native to local_reviewer"* ]] || fail "project-local workflow did not fall back to the healthy agent"
assert_contains "$GEMINI_LOG" "gemini --project-scope Workflow prompt"
assert_contains "$GEMINI_LOG" "gemini --local-fallback Workflow prompt"

unusable_failure="$(
  cd "$TEST_REPO" && PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" unusable 2>&1 >/dev/null || true
)"
[[ "$unusable_failure" == *"no available agent candidates for workflow: unusable"* ]] || fail "unusable workflow did not report aggregate failure"
[[ "$unusable_failure" == *"resolution_candidates: broken_native, missing_native"* ]] || fail "unusable workflow did not report candidate ordering"
[[ "$unusable_failure" == *"candidate broken_native: missing prompt file: $TEST_REPO/.ai-dev-os/prompts/missing.md"* ]] || fail "unusable workflow did not report prompt failure"
[[ "$unusable_failure" == *"candidate missing_native: missing dependency: missing-codex"* ]] || fail "unusable workflow did not report dependency failure"
[[ "$unusable_failure" == *"run: ai doctor"* ]] || fail "unusable workflow did not suggest ai doctor"

unknown_output="$(PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" nope 2>&1 >/dev/null || true)"
[[ "$unknown_output" == *"run \`ai doctor\` to diagnose repo/runtime readiness first"* ]] || fail "unknown ai command did not include doctor remediation"
[[ "$unknown_output" == *"run \`ai workflows\` to see available workflow aliases and descriptions"* ]] || fail "unknown ai command did not include workflow remediation"
unknown_doctor_line="$(printf '%s\n' "$unknown_output" | rg '^run `ai doctor`' -n)"
unknown_workflows_line="$(printf '%s\n' "$unknown_output" | rg '^run `ai workflows`' -n)"
[[ -n "$unknown_doctor_line" && -n "$unknown_workflows_line" ]] || fail "unknown ai command did not print ordered recovery lines"
[[ "${unknown_doctor_line%%:*}" -lt "${unknown_workflows_line%%:*}" ]] || fail "unknown ai command did not point to ai doctor before ai workflows"

echo "ai cli test passed"
