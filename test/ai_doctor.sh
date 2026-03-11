#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TEST_REPO="$TMPDIR_ROOT/project"
STUB_BIN="$TMPDIR_ROOT/bin"
TEST_HOME="$TMPDIR_ROOT/home"
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
  mkdir -p "$TEST_REPO/.git" "$TEST_REPO/.ai-dev-os/prompts" "$STUB_BIN" "$TEST_HOME"
  printf "doctor\n" > "$TEST_REPO/README.md"

  cat > "$TEST_REPO/.ai-dev-os/prompts/local-reviewer.md" <<'EOF'
# Local Reviewer

Review the local repository.
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
    project_config: .gemini/settings.json
    user_config: ~/.gemini/settings.json
    mcp_config: ~/.gemini/settings.json
    trust_template: templates/ai-trust/gemini-settings.json
  claude_native:
    provider: anthropic
    command: claude
    role: implementer
    description: Claude native runtime checks
    prompt_file: .ai-dev-os/prompts/local-reviewer.md
    prompt_handoff: append-system-prompt
    context_handoff: prompt
    project_config: .claude/settings.json
    user_config: ~/.claude/settings.json
    mcp_config: .claude/settings.json
    project_extensions: .claude/agents/
    trust_template: templates/ai-trust/claude-settings.json
  broken_native:
    provider: google
    command: gemini
    role: reviewer
    description: Broken prompt workflow
    prompt_file: .ai-dev-os/prompts/missing.md
    prompt_handoff: prompt
    context_handoff: prompt
    project_config: .gemini/settings.json
    user_config: ~/.gemini/settings.json
    trust_template: templates/ai-trust/gemini-settings.json
  missing_native:
    provider: openai
    command: missing-codex
    role: reviewer
    description: Missing backend workflow
    prompt_file: .ai-dev-os/prompts/local-reviewer.md
    prompt_handoff: prompt
    context_handoff: prompt
    project_config: .codex/config.toml
    user_config: ~/.codex/config.toml
    trust_template: templates/ai-trust/codex-config.toml
EOF

  cat > "$TEST_REPO/.ai-dev-os/workflows.yml" <<'EOF'
workflows:
  native:
    default_agent: local_reviewer
    description: Healthy workflow
  broken_fallback:
    default_agent: broken_native
    fallback_agents: local_reviewer
    description: Broken primary prompt with fallback
  unusable:
    default_agent: broken_native
    fallback_agents: missing_native
    description: No viable candidates
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
  branch)
    if [[ "${2:-}" == "--show-current" ]]; then
      printf "main\n"
      exit 0
    fi
    exit 1
    ;;
  log)
    printf "abc123 setup\n"
    ;;
  *)
    exit 1
    ;;
esac
EOF

  cat > "$STUB_BIN/gemini" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "gemini %s\n" "$*" >/dev/null
EOF

  cat > "$STUB_BIN/claude" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "claude %s\n" "$*" >/dev/null
EOF

  chmod +x "$STUB_BIN/git" "$STUB_BIN/gemini" "$STUB_BIN/claude"
}

setup_project
setup_stubs

doctor_output="$(
  cd "$TEST_REPO" && HOME="$TEST_HOME" PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" doctor 2>&1 || true
)"

[[ "$doctor_output" == *"AI Dev OS doctor"* ]] || fail "ai doctor did not print the header"
[[ "$doctor_output" == *"agents_config: $TEST_REPO/.ai-dev-os/agents.yml"* ]] || fail "ai doctor did not report local agent config"
[[ "$doctor_output" == *"workflows_config: $TEST_REPO/.ai-dev-os/workflows.yml"* ]] || fail "ai doctor did not report local workflow config"
[[ "$doctor_output" == *"workflow: broken_fallback"* ]] || fail "ai doctor did not report the fallback workflow"
[[ "$doctor_output" == *"candidate broken_native: FAIL missing prompt file: $TEST_REPO/.ai-dev-os/prompts/missing.md"* ]] || fail "ai doctor did not report missing prompt file"
[[ "$doctor_output" == *"status: WARN fallback to local_reviewer"* ]] || fail "ai doctor did not report fallback workflow status"
[[ "$doctor_output" == *"selected_agent: local_reviewer"* ]] || fail "ai doctor did not report the fallback agent"
[[ "$doctor_output" == *"workflow: unusable"* ]] || fail "ai doctor did not report the unusable workflow"
[[ "$doctor_output" == *"candidate missing_native: FAIL missing dependency: missing-codex"* ]] || fail "ai doctor did not report missing dependency"
[[ "$doctor_output" == *"status: FAIL no available candidates"* ]] || fail "ai doctor did not report failed workflow resolution"
[[ "$doctor_output" == *"agent: local_reviewer"* ]] || fail "ai doctor did not print agent diagnostics"
[[ "$doctor_output" == *"project_config: WARN $TEST_REPO/.gemini/settings.json (run: ai trust init gemini --project --repo $TEST_REPO)"* ]] || fail "ai doctor did not report missing project config"
[[ "$doctor_output" == *"user_config: WARN $TEST_HOME/.gemini/settings.json (run: ai trust init gemini --user)"* ]] || fail "ai doctor did not report missing user config"
[[ "$doctor_output" == *"mcp_config: WARN $TEST_HOME/.gemini/settings.json (run: ai trust init gemini --user)"* ]] || fail "ai doctor did not report missing MCP config"
[[ "$doctor_output" == *"trust_template: OK $REPO/templates/ai-trust/gemini-settings.json"* ]] || fail "ai doctor did not report trust template"
[[ "$doctor_output" == *"context_summary: OK $TEST_REPO/.context/summary.md"* ]] || fail "ai doctor did not report context summary"
[[ "$doctor_output" == *"agent: claude_native"* ]] || fail "ai doctor did not report claude native diagnostics"
[[ "$doctor_output" == *"mcp_config: WARN $TEST_REPO/.claude/settings.json (run: ai trust init claude --project --repo $TEST_REPO)"* ]] || fail "ai doctor did not report project-scoped MCP config"
[[ "$doctor_output" == *"project_extensions: WARN $TEST_REPO/.claude/agents/ (create the directory and add vendor-native project extensions if needed)"* ]] || fail "ai doctor did not report missing project extensions"

filtered_output="$(
  cd "$TEST_REPO" && HOME="$TEST_HOME" PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai-doctor" --workflow native --agent local_reviewer
)"
[[ "$filtered_output" == *"workflow: native"* ]] || fail "filtered ai-doctor output did not include the selected workflow"
[[ "$filtered_output" == *"agent: local_reviewer"* ]] || fail "filtered ai-doctor output did not include the selected agent"
[[ "$filtered_output" != *"workflow: unusable"* ]] || fail "filtered ai-doctor output included unrelated workflows"

doctor_failure="$(
  cd "$TEST_REPO"
  set +e
  HOME="$TEST_HOME" PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" doctor >/dev/null 2>&1
  status="$?"
  set -e
  printf '%s' "$status"
)"
[[ "$doctor_failure" == "1" ]] || fail "ai doctor should exit non-zero when a workflow is unusable"

echo "ai doctor test passed"
