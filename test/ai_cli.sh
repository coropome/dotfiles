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
  mkdir -p "$TEST_REPO/.git" "$STUB_BIN"
  printf "hello\n" > "$TEST_REPO/README.md"
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

  chmod +x "$STUB_BIN/git" "$STUB_BIN/tmux" "$STUB_BIN/open" "$STUB_BIN/pbcopy" "$STUB_BIN/claude" "$STUB_BIN/codex"
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
assert_contains "$TMUX_LOG" "new-session -d -s ai-dev-os-project -n workspace -c $TEST_REPO"
assert_contains "$TMUX_LOG" "send-keys -t ai-dev-os-project:workspace.1 $REPO/bin/ai-context --repo $TEST_REPO --show"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" stop --repo "$TEST_REPO" >/dev/null
assert_contains "$TMUX_LOG" "kill-session -t ai-dev-os-project"

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" code >/dev/null
assert_contains "$CLAUDE_LOG" "claude "

PATH="$STUB_BIN:$ORIG_PATH" "$REPO/bin/ai" review >/dev/null
assert_contains "$CODEX_LOG" "codex "

echo "ai cli test passed"
