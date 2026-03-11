#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
STUB_BIN="$TMPDIR_ROOT/bin"
TEST_HOME="$TMPDIR_ROOT/home"
DOCTOR_OUT="$TMPDIR_ROOT/doctor.out"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

setup_stubs() {
  mkdir -p "$STUB_BIN" "$TEST_HOME"

  cat > "$STUB_BIN/uname" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "-m" ]]; then
  printf "x86_64\n"
else
  printf "Linux\n"
fi
EOF

  cat > "$STUB_BIN/git" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  --version)
    printf "git version 2.39.0\n"
    ;;
  config)
    case "${3:-}" in
      --get|--get-all|--includes)
        exit 0
        ;;
      *)
        exit 0
        ;;
    esac
    ;;
  version)
    printf "git version 2.39.0\n"
    ;;
  *)
    exit 0
    ;;
esac
EOF

  cat > "$STUB_BIN/tmux" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "tmux 3.1c\n"
EOF

  cat > "$STUB_BIN/zsh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "zsh 5.9\n"
EOF

  chmod +x "$STUB_BIN/uname" "$STUB_BIN/git" "$STUB_BIN/tmux" "$STUB_BIN/zsh"
}

run_doctor() {
  HOME="$TEST_HOME" PATH="$STUB_BIN:/usr/bin:/bin" "$REPO/doctor.sh" > "$DOCTOR_OUT"
}

run_doctor_with_proc_version() {
  local proc_version="$1"
  HOME="$TEST_HOME" PATH="$STUB_BIN:/usr/bin:/bin" DITFILES_TEST_PROC_VERSION="$proc_version" "$REPO/doctor.sh" > "$DOCTOR_OUT"
}

assert_contains() {
  local expected="$1"
  grep -Fq "$expected" "$DOCTOR_OUT" || fail "doctor output missing: $expected"
}

setup_stubs
run_doctor

assert_contains "[WARN] not macOS (bootstrap is macOS-first; doctor is best-effort here)"
assert_contains "[NG] brew not found (manual bootstrap on non-macOS; see docs/31-support-matrix.md)"
assert_contains "[NG] claude not found (manual agent setup on non-macOS; see docs/31-support-matrix.md)"
assert_contains "[NG] gemini not found (manual agent setup on non-macOS; see docs/31-support-matrix.md)"
assert_contains "[NG] codex not found (manual agent setup on non-macOS; see docs/31-support-matrix.md)"
assert_contains "[NG] $TEST_HOME/.zshrc missing (manual bootstrap on non-macOS; see docs/31-support-matrix.md)"
assert_contains "[NG] git include.path missing (manual bootstrap on non-macOS; see docs/31-support-matrix.md)"
assert_contains "[..] xcode-select: skipped on non-macOS"
assert_contains "[NG] ai-open backend missing: xdg-open (install xdg-utils on Linux)"
assert_contains "[NG] ai-copy backend missing: install wl-copy, xclip, or xsel on Linux"

run_doctor_with_proc_version "Linux version Microsoft"

assert_contains "[..] platform variant: WSL"
assert_contains "[NG] ai-open backend missing: install wslu for wslview or ensure explorer.exe is available in WSL"
assert_contains "[NG] ai-copy backend missing: clip.exe (run from WSL with Windows integration enabled)"

echo "doctor platform test passed"
