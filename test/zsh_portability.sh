#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
STUB_BIN="$TMPDIR_ROOT/bin"
ORIG_PATH="$PATH"
TAR_LOG="$TMPDIR_ROOT/tar.log"
UNZSTD_LOG="$TMPDIR_ROOT/unzstd.log"

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

  cat > "$STUB_BIN/fzf" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--zsh" ]]; then
  exit 1
fi

echo "unexpected fzf args: $*" >&2
exit 1
EOF

  cat > "$STUB_BIN/tar" <<EOF
#!/usr/bin/env bash
set -euo pipefail

if [[ "\${1:-}" == "--help" ]]; then
  printf "usage: tar\\n"
  exit 0
fi

printf "%s\\n" "\$*" >> "$TAR_LOG"
cat >/dev/null
EOF

  cat > "$STUB_BIN/unzstd" <<EOF
#!/usr/bin/env bash
set -euo pipefail

printf "%s\\n" "\$*" >> "$UNZSTD_LOG"
printf "fake tar stream"
EOF

  chmod +x "$STUB_BIN/fzf" "$STUB_BIN/tar" "$STUB_BIN/unzstd"
}

assert_equals() {
  local actual="$1"
  local expected="$2"
  [[ "$actual" == "$expected" ]] || fail "expected '$expected', got '$actual'"
}

verify_fzf_packaged_script_fallback() {
  local prefix="$TMPDIR_ROOT/homebrew"
  local output

  mkdir -p "$prefix/opt/fzf/shell"
  cat > "$prefix/opt/fzf/shell/completion.zsh" <<'EOF'
export DITFILES_FZF_COMPLETION_LOADED=1
EOF
  cat > "$prefix/opt/fzf/shell/key-bindings.zsh" <<'EOF'
export DITFILES_FZF_KEYBINDINGS_LOADED=1
EOF

  output="$(
    PATH="$STUB_BIN:$ORIG_PATH" HOMEBREW_PREFIX="$prefix" zsh -c '
      source "'"$REPO"'/zsh/modules/00-lib.zsh"
      source "'"$REPO"'/zsh/modules/70-tools.zsh"
      print -r -- "${DITFILES_FZF_COMPLETION_LOADED:-0}:${DITFILES_FZF_KEYBINDINGS_LOADED:-0}"
    '
  )"

  assert_equals "$output" "1:1"
}

verify_extract_tar_zst_fallback() {
  local archive="$TMPDIR_ROOT/demo.tar.zst"

  : > "$archive"
  : > "$TAR_LOG"
  : > "$UNZSTD_LOG"

  PATH="$STUB_BIN:$ORIG_PATH" zsh -c '
    source "'"$REPO"'/zsh/modules/00-lib.zsh"
    source "'"$REPO"'/zsh/modules/60-aliases-functions.zsh"
    extract "'"$archive"'"
  '

  assert_equals "$(cat "$UNZSTD_LOG")" "-c $archive"
  assert_equals "$(cat "$TAR_LOG")" "xf -"
}

setup_stubs
verify_fzf_packaged_script_fallback
verify_extract_tar_zst_fallback

echo "zsh portability test passed"
