#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TEST_REPO="$TMPDIR_ROOT/repo"
STUB_BIN="$TMPDIR_ROOT/bin"
BREW_LOG="$TMPDIR_ROOT/brew.log"
DOCTOR_LOG="$TMPDIR_ROOT/doctor.log"
ORIG_PATH="$PATH"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

setup_repo() {
  mkdir -p "$TEST_REPO/manifests/packages" "$STUB_BIN"
  cp "$REPO/Makefile" "$TEST_REPO/Makefile"
  cp "$REPO/manifests/packages/agent-brew.txt" "$TEST_REPO/manifests/packages/agent-brew.txt"
  cp "$REPO/manifests/packages/agent-cask.txt" "$TEST_REPO/manifests/packages/agent-cask.txt"

  cat > "$TEST_REPO/doctor.sh" <<EOF
#!/usr/bin/env bash
set -euo pipefail
printf "doctor called\n" > "$DOCTOR_LOG"
EOF
  chmod +x "$TEST_REPO/doctor.sh"
}

setup_stubs() {
  cat > "$STUB_BIN/brew" <<EOF
#!/usr/bin/env bash
set -euo pipefail
printf "%s\n" "\$*" >> "$BREW_LOG"
EOF
  chmod +x "$STUB_BIN/brew"
}

assert_file_lines() {
  local file="$1"
  shift
  [[ -f "$file" ]] || fail "missing log file: $file"
  local expected actual
  expected="$(printf "%s\n" "$@")"
  actual="$(cat "$file")"
  [[ "$actual" == "$expected" ]] || fail "$file contained:\n$actual\nexpected:\n$expected"
}

setup_repo
setup_stubs

PATH="$STUB_BIN:$ORIG_PATH" make -C "$TEST_REPO" agent >/dev/null

assert_file_lines "$BREW_LOG" \
  "install gemini-cli" \
  "install --cask claude-code" \
  "install --cask codex"

assert_file_lines "$DOCTOR_LOG" "doctor called"

echo "agent install test passed"
