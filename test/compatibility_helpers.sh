#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
STUB_BIN="$TMPDIR_ROOT/bin"
ORIG_PATH="$PATH"
LAST_CMD="$TMPDIR_ROOT/last_cmd"
LAST_STDIN="$TMPDIR_ROOT/last_stdin"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

setup_stubs() {
  mkdir -p "$STUB_BIN"

  cat > "$STUB_BIN/pbcopy" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "pbcopy %s\n" "$*" > "$DITFILES_TEST_LAST_CMD"
cat > "$DITFILES_TEST_LAST_STDIN"
EOF

  cat > "$STUB_BIN/wl-copy" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "wl-copy %s\n" "$*" > "$DITFILES_TEST_LAST_CMD"
cat > "$DITFILES_TEST_LAST_STDIN"
EOF

  cat > "$STUB_BIN/xclip" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "xclip %s\n" "$*" > "$DITFILES_TEST_LAST_CMD"
cat > "$DITFILES_TEST_LAST_STDIN"
EOF

  cat > "$STUB_BIN/xsel" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "xsel %s\n" "$*" > "$DITFILES_TEST_LAST_CMD"
cat > "$DITFILES_TEST_LAST_STDIN"
EOF

  cat > "$STUB_BIN/clip.exe" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "clip.exe %s\n" "$*" > "$DITFILES_TEST_LAST_CMD"
cat > "$DITFILES_TEST_LAST_STDIN"
EOF

  cat > "$STUB_BIN/open" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "open %s\n" "$*" > "$DITFILES_TEST_LAST_CMD"
EOF

  cat > "$STUB_BIN/xdg-open" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "xdg-open %s\n" "$*" > "$DITFILES_TEST_LAST_CMD"
EOF

  cat > "$STUB_BIN/wslview" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "wslview %s\n" "$*" > "$DITFILES_TEST_LAST_CMD"
EOF

  cat > "$STUB_BIN/tmux" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf "tmux %s\n" "$*" > "$DITFILES_TEST_LAST_CMD"
EOF

  chmod +x "$STUB_BIN/"*
}

reset_records() {
  rm -f "$LAST_CMD" "$LAST_STDIN"
}

assert_file_equals() {
  local target="$1"
  local expected="$2"
  [[ -f "$target" ]] || fail "$target was not created"
  [[ "$(cat "$target")" == "$expected" ]] || fail "$target was '$(cat "$target")', expected '$expected'"
}

run_with_test_env() {
  DITFILES_TEST_LAST_CMD="$LAST_CMD" \
  DITFILES_TEST_LAST_STDIN="$LAST_STDIN" \
  PATH="$STUB_BIN:$ORIG_PATH" \
  env "$@"
}

verify_platform_detection() {
  [[ "$(DITFILES_TEST_UNAME_S=Darwin "$REPO/bin/_platform")" == "darwin" ]] \
    || fail "expected darwin variant"
  [[ "$(DITFILES_TEST_UNAME_S=Linux "$REPO/bin/_platform")" == "linux" ]] \
    || fail "expected linux variant"
  [[ "$(DITFILES_TEST_UNAME_S=Linux DITFILES_TEST_PROC_VERSION='Linux version Microsoft' "$REPO/bin/_platform")" == "wsl" ]] \
    || fail "expected wsl variant"
  DITFILES_TEST_UNAME_S=Linux DITFILES_TEST_PROC_VERSION='Linux version Microsoft' "$REPO/bin/_platform" --is-wsl \
    || fail "expected --is-wsl to succeed"
}

verify_clipboard_copy_adapters() {
  reset_records
  printf "darwin" | run_with_test_env DITFILES_TEST_UNAME_S=Darwin "$REPO/bin/_clipboard_copy"
  assert_file_equals "$LAST_CMD" "pbcopy "
  assert_file_equals "$LAST_STDIN" "darwin"

  reset_records
  rm -f "$STUB_BIN/wl-copy"
  printf "linux" | run_with_test_env DITFILES_TEST_UNAME_S=Linux "$REPO/bin/_clipboard_copy"
  assert_file_equals "$LAST_CMD" "xclip -selection clipboard"
  assert_file_equals "$LAST_STDIN" "linux"

  reset_records
  rm -f "$STUB_BIN/xclip"
  printf "wsl" | run_with_test_env DITFILES_TEST_UNAME_S=Linux DITFILES_TEST_PROC_VERSION='Linux version Microsoft' "$REPO/bin/_clipboard_copy"
  assert_file_equals "$LAST_CMD" "clip.exe "
  assert_file_equals "$LAST_STDIN" "wsl"
}

verify_open_adapters() {
  reset_records
  run_with_test_env DITFILES_TEST_UNAME_S=Darwin "$REPO/bin/_open" "https://example.com"
  assert_file_equals "$LAST_CMD" "open https://example.com"

  reset_records
  run_with_test_env DITFILES_TEST_UNAME_S=Linux "$REPO/bin/_open" "/tmp/demo"
  assert_file_equals "$LAST_CMD" "xdg-open /tmp/demo"

  reset_records
  run_with_test_env DITFILES_TEST_UNAME_S=Linux DITFILES_TEST_PROC_VERSION='Linux version Microsoft' "$REPO/bin/_open" "https://wsl.example"
  assert_file_equals "$LAST_CMD" "wslview https://wsl.example"
}

verify_tmux_help_adapter() {
  reset_records
  run_with_test_env DITFILES_TEST_TMUX_VERSION=3.3 "$REPO/bin/_tmux_help"
  assert_file_equals "$LAST_CMD" "tmux display-popup -E $REPO/bin/thelp"

  reset_records
  run_with_test_env DITFILES_TEST_TMUX_VERSION=3.1 "$REPO/bin/_tmux_help" full
  assert_file_equals "$LAST_CMD" "tmux split-window -v $REPO/bin/thelp full; printf '\\nPress Enter to close...'; read -r _"
}

setup_stubs
verify_platform_detection
verify_clipboard_copy_adapters
verify_open_adapters
verify_tmux_help_adapter

echo "compatibility helper tests passed"
