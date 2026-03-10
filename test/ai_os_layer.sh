#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
STUB_BIN="$TMPDIR_ROOT/bin"
LAST_CMD="$TMPDIR_ROOT/last_cmd"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

make_stub() {
  local name="$1"
  mkdir -p "$STUB_BIN"
  cat > "$STUB_BIN/$name" <<EOF
#!/usr/bin/env bash
set -euo pipefail
printf "%s %s\n" "$name" "\$*" > "$LAST_CMD"
EOF
  chmod +x "$STUB_BIN/$name"
}

assert_file_equals() {
  local path="$1"
  local expected="$2"
  [[ -f "$path" ]] || fail "$path missing"
  [[ "$(cat "$path")" == "$expected" ]] || fail "$path was '$(cat "$path")', expected '$expected'"
}

reset_state() {
  rm -f "$LAST_CMD"
  rm -rf "$STUB_BIN"
  mkdir -p "$STUB_BIN"
}

linux_pkg_manager_prefers_apk_when_available() {
  reset_state
  make_stub apk
  result="$(PATH="$STUB_BIN:/usr/bin:/bin" bash -lc 'source "'"$REPO"'/os/linux.sh"; ai_os_linux_pkg_manager')"
  [[ "$result" == "apk" ]] || fail "expected apk, got '$result'"
}

linux_open_requires_xdg_open() {
  reset_state
  error_output="$(
    PATH="$STUB_BIN:/usr/bin:/bin" bash -lc 'source "'"$REPO"'/os/linux.sh"; ai_os_open "https://example.com"' 2>&1 >/dev/null || true
  )"
  [[ "$error_output" == *"xdg-open not found"* ]] || fail "missing xdg-open remediation"
}

linux_copy_reports_missing_clipboard_tool() {
  reset_state
  error_output="$(
    PATH="$STUB_BIN:/usr/bin:/bin" bash -lc 'source "'"$REPO"'/os/linux.sh"; ai_os_copy' 2>&1 >/dev/null || true
  )"
  [[ "$error_output" == *"no supported Linux clipboard tool found"* ]] || fail "missing Linux clipboard remediation"
}

wsl_open_falls_back_to_explorer() {
  reset_state
  make_stub explorer.exe
  PATH="$STUB_BIN:/usr/bin:/bin" bash -lc 'source "'"$REPO"'/os/wsl.sh"; ai_os_open "https://example.com"'
  assert_file_equals "$LAST_CMD" "explorer.exe https://example.com"
}

wsl_copy_reports_missing_clip_exe() {
  reset_state
  error_output="$(
    PATH="$STUB_BIN:/usr/bin:/bin" bash -lc 'source "'"$REPO"'/os/wsl.sh"; ai_os_copy' 2>&1 >/dev/null || true
  )"
  [[ "$error_output" == *"clip.exe not found"* ]] || fail "missing WSL clipboard remediation"
}

linux_pkg_manager_prefers_apk_when_available
linux_open_requires_xdg_open
linux_copy_reports_missing_clipboard_tool
wsl_open_falls_back_to_explorer
wsl_copy_reports_missing_clip_exe

echo "os layer test passed"
