#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TEST_REPO="$TMPDIR_ROOT/repo"
STUB_BIN="$TMPDIR_ROOT/bin"
PLAYBOOK_ARGS="$TMPDIR_ROOT/ansible_playbook_args"
GALAXY_ARGS="$TMPDIR_ROOT/ansible_galaxy_args"
ORIG_PATH="$PATH"
RUNNER_STDOUT="$TMPDIR_ROOT/runner_stdout"
RUNNER_STDERR="$TMPDIR_ROOT/runner_stderr"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

setup_repo() {
  mkdir -p "$TEST_REPO/ansible/inventory" "$STUB_BIN"
  cp "$REPO/ansible/run.sh" "$TEST_REPO/ansible/run.sh"
  printf -- "---\ncollections: []\n" > "$TEST_REPO/ansible/requirements.yml"
  : > "$TEST_REPO/ansible/macos.yml"
  : > "$TEST_REPO/ansible/inventory/localhost.ini"
}

setup_stubs() {
  cat > "$STUB_BIN/brew" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "brew should not be called in this test" >&2
exit 1
EOF

  cat > "$STUB_BIN/uname" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "-s" || $# -eq 0 ]]; then
  printf "Darwin\n"
  exit 0
fi

echo "unsupported uname args: $*" >&2
exit 1
EOF

  cat > "$STUB_BIN/xcode-select" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "-p" ]]; then
  printf "/Library/Developer/CommandLineTools\n"
  exit 0
fi

echo "unsupported xcode-select args: $*" >&2
exit 1
EOF

  cat > "$STUB_BIN/ansible-galaxy" <<EOF
#!/usr/bin/env bash
set -euo pipefail

printf "%s\n" "\$*" > "$GALAXY_ARGS"
EOF

  cat > "$STUB_BIN/ansible-playbook" <<EOF
#!/usr/bin/env bash
set -euo pipefail

printf "%s\n" "\$*" > "$PLAYBOOK_ARGS"
EOF

  chmod +x "$STUB_BIN/brew" "$STUB_BIN/uname" "$STUB_BIN/xcode-select" "$STUB_BIN/ansible-galaxy" "$STUB_BIN/ansible-playbook"
}

run_runner() {
  (
    cd "$TMPDIR_ROOT"
    PATH="$STUB_BIN:$ORIG_PATH" "$TEST_REPO/ansible/run.sh" "$@"
  )
}

run_runner_capture() {
  rm -f "$RUNNER_STDOUT" "$RUNNER_STDERR"
  (
    cd "$TMPDIR_ROOT"
    PATH="$STUB_BIN:$ORIG_PATH" "$TEST_REPO/ansible/run.sh" "$@"
  ) >"$RUNNER_STDOUT" 2>"$RUNNER_STDERR"
}

assert_playbook_args() {
  local expected="$1"
  [[ -f "$PLAYBOOK_ARGS" ]] || fail "ansible-playbook was not invoked"
  [[ "$(cat "$PLAYBOOK_ARGS")" == "$expected" ]] \
    || fail "ansible-playbook args were '$(cat "$PLAYBOOK_ARGS")', expected '$expected'"
}

assert_galaxy_args() {
  [[ -f "$GALAXY_ARGS" ]] || fail "ansible-galaxy was not invoked"
  [[ "$(cat "$GALAXY_ARGS")" == "collection install -r $TEST_REPO/ansible/requirements.yml" ]] \
    || fail "ansible-galaxy args were '$(cat "$GALAXY_ARGS")'"
}

verify_runner_without_local_yml() {
  rm -f "$TEST_REPO/ansible/local.yml" "$PLAYBOOK_ARGS" "$GALAXY_ARGS"

  run_runner --tags brew

  assert_galaxy_args
  assert_playbook_args "-i $TEST_REPO/ansible/inventory/localhost.ini $TEST_REPO/ansible/macos.yml --tags brew"
}

verify_runner_with_local_yml() {
  rm -f "$PLAYBOOK_ARGS" "$GALAXY_ARGS"
  printf "git_name: test\n" > "$TEST_REPO/ansible/local.yml"

  run_runner --tags dock

  assert_galaxy_args
  assert_playbook_args "-i $TEST_REPO/ansible/inventory/localhost.ini $TEST_REPO/ansible/macos.yml -e @$TEST_REPO/ansible/local.yml --tags dock"
}

verify_runner_rejects_unknown_phase() {
  rm -f "$PLAYBOOK_ARGS" "$GALAXY_ARGS"

  if run_runner_capture --phase nope; then
    fail "ansible/run.sh accepted an unknown phase"
  fi

  grep -Fq "unknown phase: nope" "$RUNNER_STDERR" \
    || fail "ansible/run.sh did not report the unknown phase"
}

verify_runner_auto_preflight_for_playbook_phase() {
  rm -f "$PLAYBOOK_ARGS" "$GALAXY_ARGS"
  rm -f "$TEST_REPO/ansible/local.yml"

  run_runner_capture --phase playbook --syntax-check

  grep -Fq "==> Running Ansible preflight..." "$RUNNER_STDOUT" \
    || fail "ansible/run.sh did not auto-run preflight for --phase playbook"
  assert_playbook_args "-i $TEST_REPO/ansible/inventory/localhost.ini $TEST_REPO/ansible/macos.yml --syntax-check"
}

setup_repo
setup_stubs
verify_runner_without_local_yml
verify_runner_with_local_yml
verify_runner_rejects_unknown_phase
verify_runner_auto_preflight_for_playbook_phase

echo "ansible runner test passed"
