#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TEST_HOME="$TMPDIR_ROOT/home"
STUB_BIN="$TMPDIR_ROOT/bin"
SELECTED_PWD="$TMPDIR_ROOT/selected_pwd"
ORIG_PATH="$PATH"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

setup_stubs() {
  mkdir -p "$TEST_HOME" "$STUB_BIN"

  cat > "$STUB_BIN/tnew" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

printf "%s\n" "$PWD" > "${P_TEST_SELECTED_PWD:?}"
EOF

  cat > "$STUB_BIN/fzf" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

head -n 1
EOF

  chmod +x "$STUB_BIN/tnew" "$STUB_BIN/fzf"
}

run_p() {
  local root="$1"
  rm -f "$SELECTED_PWD"
  P_TEST_SELECTED_PWD="$SELECTED_PWD" \
    HOME="$TEST_HOME" \
    PATH="$STUB_BIN:$ORIG_PATH" \
    DITFILES_PROJECT_ROOTS="$root" \
    "$REPO/bin/p" >/dev/null
}

run_p_with_ai_dev_os_roots() {
  local root="$1"
  rm -f "$SELECTED_PWD"
  P_TEST_SELECTED_PWD="$SELECTED_PWD" \
    HOME="$TEST_HOME" \
    PATH="$STUB_BIN:$ORIG_PATH" \
    AI_DEV_OS_PROJECT_ROOTS="$root" \
    "$REPO/bin/p" >/dev/null
}

assert_selected_pwd() {
  local expected="$1"
  [[ -f "$SELECTED_PWD" ]] || fail "tnew was not invoked"
  [[ "$(cat "$SELECTED_PWD")" == "$expected" ]] \
    || fail "selected pwd was $(cat "$SELECTED_PWD"), expected $expected"
}

verify_p_runs_on_bash32() {
  local projects_root="$TMPDIR_ROOT/projects"

  mkdir -p "$projects_root/alpha/.git"

  run_p "$projects_root"
  assert_selected_pwd "$projects_root/alpha"
}

verify_p_detects_git_worktree_files() {
  local projects_root="$TMPDIR_ROOT/worktrees"

  mkdir -p "$projects_root/beta"
  printf "gitdir: %s\n" "$TMPDIR_ROOT/fake-git-dir" > "$projects_root/beta/.git"

  run_p "$projects_root"
  assert_selected_pwd "$projects_root/beta"
}

verify_p_prefers_ai_dev_os_project_roots() {
  local preferred_root="$TMPDIR_ROOT/ai-dev-os-projects"
  local fallback_root="$TMPDIR_ROOT/ditfiles-projects"

  mkdir -p "$preferred_root/gamma/.git"
  mkdir -p "$fallback_root/delta/.git"

  rm -f "$SELECTED_PWD"
  P_TEST_SELECTED_PWD="$SELECTED_PWD" \
    HOME="$TEST_HOME" \
    PATH="$STUB_BIN:$ORIG_PATH" \
    AI_DEV_OS_PROJECT_ROOTS="$preferred_root" \
    DITFILES_PROJECT_ROOTS="$fallback_root" \
    "$REPO/bin/p" >/dev/null

  assert_selected_pwd "$preferred_root/gamma"
}

setup_stubs
verify_p_runs_on_bash32
verify_p_detects_git_worktree_files
verify_p_prefers_ai_dev_os_project_roots

echo "p helper test passed"
