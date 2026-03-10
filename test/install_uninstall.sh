#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
TEST_HOME="$TMPDIR_ROOT/home"
STUB_BIN="$TMPDIR_ROOT/bin"
ORIG_PATH="$PATH"

cleanup() {
  rm -rf "$TMPDIR_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_symlink() {
  local target="$1"
  local expected="$2"
  local actual
  [[ -L "$target" ]] || fail "$target is not a symlink"
  actual="$(readlink "$target")"
  [[ "$actual" == "$expected" ]] || fail "$target -> $actual (expected $expected)"
}

assert_not_exists() {
  local target="$1"
  [[ ! -e "$target" && ! -L "$target" ]] || fail "$target still exists"
}

assert_backup_exists() {
  local target="$1"
  local matches=()
  shopt -s nullglob
  matches=( "${target}.bak."* )
  shopt -u nullglob
  [[ ${#matches[@]} -gt 0 ]] || fail "backup not created for $target"
}

count_backups() {
  find "$1" -name '*.bak.*' | wc -l | tr -d ' '
}

assert_file_contents() {
  local target="$1"
  local expected="$2"
  [[ -f "$target" ]] || fail "$target is missing"
  [[ "$(cat "$target")" == "$expected" ]] || fail "$target contents differ"
}

setup_stubs() {
  mkdir -p "$STUB_BIN"

  cat > "$STUB_BIN/brew" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  bundle)
    exit 0
    ;;
  --prefix)
    printf "/opt/homebrew\n"
    ;;
  doctor)
    exit 0
    ;;
  *)
    echo "unsupported brew invocation: $*" >&2
    exit 1
    ;;
esac
EOF

  cat > "$STUB_BIN/git" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

state_file="${HOME}/.test_git_include"

git_value_for_key() {
  local key="$1"

  case "$key" in
    core.pager)
      printf "delta\n"
      ;;
    core.excludesfile)
      printf "~/.config/ditfiles/gitignore_global\n"
      ;;
  esac
}

make_fake_tpm_checkout() {
  local target="$1"

  mkdir -p "$target/.git" "$target/bin"
  : > "$target/tpm"
  chmod +x "$target/tpm"
}

case "${1:-}" in
  config)
    [[ "${2:-}" == "--global" ]] || exit 1
    case "${3:-}" in
      --get-all)
        if [[ "${4:-}" == "include.path" && -f "$state_file" ]]; then
          cat "$state_file"
        fi
        ;;
      --get)
        case "${4:-}" in
          credential.helper|commit.gpgsign|gpg.format|user.signingkey)
            ;;
          *)
            git_value_for_key "${4:-}"
            ;;
        esac
        ;;
      --includes)
        [[ "${4:-}" == "--get" ]] || exit 1
        git_value_for_key "${5:-}"
        ;;
      --add)
        [[ "${4:-}" == "include.path" ]] || exit 1
        printf "%s\n" "${5:-}" >> "$state_file"
        ;;
      --unset-all)
        [[ "${4:-}" == "include.path" ]] || exit 1
        if [[ -f "$state_file" ]]; then
          grep -Fxv "${5:-}" "$state_file" > "${state_file}.tmp" || true
          mv "${state_file}.tmp" "$state_file"
        fi
        ;;
      *)
        echo "unsupported git config args: ${*:3}" >&2
        exit 1
        ;;
    esac
    ;;
  clone)
    case "${2:?}" in
      https://github.com/tmux-plugins/tpm)
        make_fake_tpm_checkout "${3:?}"
        ;;
      https://github.com/tmux-plugins/tmux-resurrect|https://github.com/tmux-plugins/tmux-continuum)
        mkdir -p "${3:?}/.git"
        ;;
      *)
        echo "unsupported git clone repo: ${2}" >&2
        exit 1
        ;;
    esac
    ;;
  -C)
    [[ "${3:-}" == "pull" && "${4:-}" == "--ff-only" ]] || exit 1
    [[ -d "${2:?}/.git" ]] || exit 1
    ;;
  *)
    echo "unsupported git invocation: $*" >&2
    exit 1
    ;;
esac
EOF

  chmod +x "$STUB_BIN/brew" "$STUB_BIN/git"
}

seed_existing_files() {
  mkdir -p \
    "$TEST_HOME/.config/tmux" \
    "$TEST_HOME/.config/ditfiles/conf.d" \
    "$TEST_HOME/.config" \
    "$TEST_HOME/.local/bin"

  printf "old zprofile" > "$TEST_HOME/.zprofile"
  printf "old zshrc" > "$TEST_HOME/.zshrc"
  printf "old tmux" > "$TEST_HOME/.config/tmux/tmux.conf"
  printf "old gitconfig" > "$TEST_HOME/.config/ditfiles/gitconfig"
  printf "old git module" > "$TEST_HOME/.config/ditfiles/conf.d/local.gitconfig"
  printf "old gitignore" > "$TEST_HOME/.config/ditfiles/gitignore_global"
  printf "old starship" > "$TEST_HOME/.config/starship.toml"
  for helper in tnew thelp tlist tgo tkill _tpick ttutor p _platform _clipboard_copy _open _tmux_help; do
    printf "old %s" "$helper" > "$TEST_HOME/.local/bin/$helper"
  done
}

run_install() {
  HOME="$TEST_HOME" PATH="$STUB_BIN:$ORIG_PATH" "$REPO/install.sh" >/dev/null
}

run_install_capture_for_home() {
  local home_dir="$1"
  local output_file="$2"
  shift 2
  HOME="$home_dir" PATH="$STUB_BIN:$ORIG_PATH" "$REPO/install.sh" "$@" >"$output_file" 2>&1
}

run_doctor() {
  HOME="$TEST_HOME" PATH="$TEST_HOME/.local/bin:$STUB_BIN:$ORIG_PATH" "$REPO/doctor.sh" > "$TMPDIR_ROOT/doctor.out"
}

run_uninstall() {
  HOME="$TEST_HOME" PATH="$STUB_BIN:$ORIG_PATH" "$REPO/uninstall.sh" >/dev/null
}

run_install_for_home() {
  local home_dir="$1"
  HOME="$home_dir" PATH="$STUB_BIN:$ORIG_PATH" "$REPO/install.sh" >/dev/null
}

run_install_from_repo_for_home() {
  local repo_dir="$1"
  local home_dir="$2"
  HOME="$home_dir" PATH="$STUB_BIN:$ORIG_PATH" "$repo_dir/install.sh" >/dev/null
}

run_uninstall_for_home() {
  local home_dir="$1"
  HOME="$home_dir" PATH="$STUB_BIN:$ORIG_PATH" "$REPO/uninstall.sh" >/dev/null
}

run_doctor_from_repo_for_home() {
  local repo_dir="$1"
  local home_dir="$2"
  local output_file="$3"
  HOME="$home_dir" PATH="$home_dir/.local/bin:$STUB_BIN:$ORIG_PATH" "$repo_dir/doctor.sh" > "$output_file"
}

verify_install() {
  assert_symlink "$TEST_HOME/.zprofile" "$REPO/.zprofile"
  assert_symlink "$TEST_HOME/.zshrc" "$REPO/zsh/zshrc"
  assert_symlink "$TEST_HOME/.config/tmux/tmux.conf" "$REPO/tmux/tmux.conf"
  assert_symlink "$TEST_HOME/.config/tmux/conf.d" "$REPO/tmux/conf.d"
  assert_symlink "$TEST_HOME/.config/ditfiles/gitconfig" "$REPO/git/gitconfig"
  assert_symlink "$TEST_HOME/.config/ditfiles/conf.d" "$REPO/git/conf.d"
  assert_symlink "$TEST_HOME/.config/ditfiles/gitignore_global" "$REPO/git/gitignore_global"
  assert_symlink "$TEST_HOME/.config/starship.toml" "$REPO/zsh/starship.toml"
  for helper in tnew thelp tlist tgo tkill _tpick ttutor p _platform _clipboard_copy _open _tmux_help; do
    assert_symlink "$TEST_HOME/.local/bin/$helper" "$REPO/bin/$helper"
  done
  [[ -d "$TEST_HOME/.tmux/plugins/tpm/.git" ]] || fail "TPM checkout was not created"
  [[ -d "$TEST_HOME/.tmux/plugins/tmux-resurrect" ]] || fail "tmux-resurrect was not installed"
  [[ -d "$TEST_HOME/.tmux/plugins/tmux-continuum" ]] || fail "tmux-continuum was not installed"

  assert_backup_exists "$TEST_HOME/.zprofile"
  assert_backup_exists "$TEST_HOME/.zshrc"
  assert_backup_exists "$TEST_HOME/.config/tmux/tmux.conf"
  assert_backup_exists "$TEST_HOME/.config/ditfiles/gitconfig"
  assert_backup_exists "$TEST_HOME/.config/ditfiles/conf.d"
  assert_backup_exists "$TEST_HOME/.config/ditfiles/gitignore_global"
  assert_backup_exists "$TEST_HOME/.config/starship.toml"
  for helper in tnew thelp tlist tgo tkill _tpick ttutor p _platform _clipboard_copy _open _tmux_help; do
    assert_backup_exists "$TEST_HOME/.local/bin/$helper"
  done

  grep -Fxq "$TEST_HOME/.config/ditfiles/gitconfig" "$TEST_HOME/.test_git_include" \
    || fail "git include path not registered"
}

verify_doctor() {
  grep -Fq "[OK] $TEST_HOME/.zshrc" "$TMPDIR_ROOT/doctor.out" \
    || fail "doctor did not validate ~/.zshrc symlink"
  grep -Fq "[OK] $TEST_HOME/.local/bin/tnew" "$TMPDIR_ROOT/doctor.out" \
    || fail "doctor did not validate helper symlink"
  grep -Fq "[OK] $TEST_HOME/.local/bin/_clipboard_copy" "$TMPDIR_ROOT/doctor.out" \
    || fail "doctor did not validate compatibility helper symlink"
  grep -Fq "[OK] git include.path registered" "$TMPDIR_ROOT/doctor.out" \
    || fail "doctor did not validate git include.path"
  grep -Fq "[OK] git core.pager (delta)" "$TMPDIR_ROOT/doctor.out" \
    || fail "doctor did not validate git core.pager"
  grep -Fq "[OK] git excludesFile (~/.config/ditfiles/gitignore_global)" "$TMPDIR_ROOT/doctor.out" \
    || fail "doctor did not validate git excludesFile"
  grep -Fq "[OK] TPM ($TEST_HOME/.tmux/plugins/tpm/tpm)" "$TMPDIR_ROOT/doctor.out" \
    || fail "doctor did not validate TPM"
  grep -Fq "[OK] tmux-resurrect" "$TMPDIR_ROOT/doctor.out" \
    || fail "doctor did not validate tmux-resurrect"
  grep -Fq "[OK] tmux-continuum" "$TMPDIR_ROOT/doctor.out" \
    || fail "doctor did not validate tmux-continuum"
}

verify_doctor_detects_broken_helper() {
  rm "$TEST_HOME/.local/bin/tnew"
  ln -s "$REPO/bin/missing-helper" "$TEST_HOME/.local/bin/tnew"

  HOME="$TEST_HOME" PATH="$TEST_HOME/.local/bin:$STUB_BIN:$ORIG_PATH" "$REPO/doctor.sh" > "$TMPDIR_ROOT/doctor_broken.out"

  grep -Fq "[NG] $TEST_HOME/.local/bin/tnew points to" "$TMPDIR_ROOT/doctor_broken.out" \
    || fail "doctor did not flag broken helper symlink"

  ln -sf "$REPO/bin/tnew" "$TEST_HOME/.local/bin/tnew"
}

verify_doctor_path_check_uses_fixed_string() {
  local dotted_home="$TMPDIR_ROOT/path-regex-home/user.name"
  local misleading_local_bin="$TMPDIR_ROOT/path-regex-home/userXname/.local/bin"
  local doctor_out="$TMPDIR_ROOT/doctor_path_regex.out"

  mkdir -p "$dotted_home" "$misleading_local_bin"
  run_install_for_home "$dotted_home"
  HOME="$dotted_home" PATH="$misleading_local_bin:$STUB_BIN:$ORIG_PATH" "$REPO/doctor.sh" > "$doctor_out"

  grep -Fq "[NG] $dotted_home/.local/bin not in PATH" "$doctor_out" \
    || fail "doctor incorrectly accepted a regex-like PATH mismatch"
}

verify_idempotent_install() {
  local backups_before backups_after

  backups_before="$(count_backups "$TEST_HOME")"
  run_install
  backups_after="$(count_backups "$TEST_HOME")"

  [[ "$backups_before" == "$backups_after" ]] \
    || fail "second install created extra backups ($backups_before -> $backups_after)"

  [[ "$(grep -Fxc "$TEST_HOME/.config/ditfiles/gitconfig" "$TEST_HOME/.test_git_include")" -eq 1 ]] \
    || fail "git include path duplicated after second install"

  [[ ! -e "$REPO/tmux/conf.d/conf.d" ]] \
    || fail "second install polluted the repo via tmux/conf.d relinking"
  [[ ! -e "$REPO/git/conf.d/conf.d" ]] \
    || fail "second install polluted the repo via git/conf.d relinking"
}

verify_install_handles_parent_directory_conflicts() {
  local conflict_home="$TMPDIR_ROOT/conflict-parent-home"

  mkdir -p "$conflict_home"
  printf "old config file" > "$conflict_home/.config"
  printf "old local file" > "$conflict_home/.local"

  run_install_for_home "$conflict_home"

  [[ -d "$conflict_home/.config" ]] || fail ".config was not converted into a directory"
  [[ -d "$conflict_home/.local" ]] || fail ".local was not converted into a directory"
  assert_backup_exists "$conflict_home/.config"
  assert_backup_exists "$conflict_home/.local"
  assert_symlink "$conflict_home/.config/tmux/tmux.conf" "$REPO/tmux/tmux.conf"
  assert_symlink "$conflict_home/.local/bin/tnew" "$REPO/bin/tnew"

  run_uninstall_for_home "$conflict_home"

  assert_file_contents "$conflict_home/.config" "old config file"
  assert_file_contents "$conflict_home/.local" "old local file"
}

verify_install_handles_nested_directory_conflicts() {
  local conflict_home="$TMPDIR_ROOT/conflict-nested-home"

  mkdir -p "$conflict_home/.config" "$conflict_home/.local"
  printf "old tmux dir file" > "$conflict_home/.config/tmux"
  printf "old ditfiles dir file" > "$conflict_home/.config/ditfiles"
  printf "old local bin file" > "$conflict_home/.local/bin"

  run_install_for_home "$conflict_home"

  [[ -d "$conflict_home/.config/tmux" ]] || fail ".config/tmux was not converted into a directory"
  [[ -d "$conflict_home/.config/ditfiles" ]] || fail ".config/ditfiles was not converted into a directory"
  [[ -d "$conflict_home/.local/bin" ]] || fail ".local/bin was not converted into a directory"
  assert_backup_exists "$conflict_home/.config/tmux"
  assert_backup_exists "$conflict_home/.config/ditfiles"
  assert_backup_exists "$conflict_home/.local/bin"

  run_uninstall_for_home "$conflict_home"

  assert_file_contents "$conflict_home/.config/tmux" "old tmux dir file"
  assert_file_contents "$conflict_home/.config/ditfiles" "old ditfiles dir file"
  assert_file_contents "$conflict_home/.local/bin" "old local bin file"
}

verify_install_rejects_unknown_phase() {
  local invalid_home="$TMPDIR_ROOT/invalid-phase-home"
  local invalid_out="$TMPDIR_ROOT/install_invalid_phase.out"

  mkdir -p "$invalid_home"

  if run_install_capture_for_home "$invalid_home" "$invalid_out" --phase nope; then
    fail "install.sh accepted an unknown phase"
  fi

  grep -Fq "unknown phase: nope" "$invalid_out" \
    || fail "install.sh did not report the unknown phase"
}

verify_install_links_auto_preflight() {
  local phase_home="$TMPDIR_ROOT/phase-links-home"
  local phase_out="$TMPDIR_ROOT/install_links_phase.out"

  mkdir -p "$phase_home"
  run_install_capture_for_home "$phase_home" "$phase_out" --phase links

  grep -Fq "==> Running bootstrap preflight..." "$phase_out" \
    || fail "install.sh did not auto-run preflight for --phase links"
  grep -Fq "==> Symlinking shell, tmux, git, and prompt config..." "$phase_out" \
    || fail "install.sh did not run the requested links phase"
}

verify_uninstall_restores_unmanaged_repo_symlink() {
  local custom_home="$TMPDIR_ROOT/unmanaged-repo-symlink-home"

  mkdir -p "$custom_home"
  ln -s "$REPO/README.md" "$custom_home/.zshrc"

  run_install_for_home "$custom_home"
  assert_backup_exists "$custom_home/.zshrc"

  run_uninstall_for_home "$custom_home"

  [[ -L "$custom_home/.zshrc" ]] || fail ".zshrc symlink was not restored"
  [[ "$(readlink "$custom_home/.zshrc")" == "$REPO/README.md" ]] \
    || fail ".zshrc symlink target was not restored"
}

verify_uninstall_preserves_user_changes_after_install() {
  local custom_home="$TMPDIR_ROOT/post-install-user-change-home"

  mkdir -p "$custom_home"
  printf "old zshrc" > "$custom_home/.zshrc"

  run_install_for_home "$custom_home"
  rm "$custom_home/.zshrc"
  printf "custom after install" > "$custom_home/.zshrc"

  run_uninstall_for_home "$custom_home"

  assert_file_contents "$custom_home/.zshrc" "custom after install"
  assert_backup_exists "$custom_home/.zshrc"
}

verify_uninstall_removes_empty_directories() {
  local clean_home="$TMPDIR_ROOT/clean-home"

  mkdir -p "$clean_home"
  run_install_for_home "$clean_home"
  run_uninstall_for_home "$clean_home"

  assert_not_exists "$clean_home/.config/tmux"
  assert_not_exists "$clean_home/.config/ditfiles"
  assert_not_exists "$clean_home/.local/bin"
}

verify_doctor_accepts_symlinked_repo_path() {
  local repo_link="$TMPDIR_ROOT/repo-link"
  local link_home="$TMPDIR_ROOT/repo-link-home"
  local doctor_out="$TMPDIR_ROOT/doctor_symlink_repo.out"

  ln -s "$REPO" "$repo_link"
  mkdir -p "$link_home"

  run_install_from_repo_for_home "$repo_link" "$link_home"
  run_doctor_from_repo_for_home "$repo_link" "$link_home" "$doctor_out"

  grep -Fq "[OK] $link_home/.zshrc" "$doctor_out" \
    || fail "doctor did not accept ~/.zshrc installed from a symlinked repo path"
}

verify_uninstall() {
  assert_file_contents "$TEST_HOME/.zprofile" "old zprofile"
  assert_file_contents "$TEST_HOME/.zshrc" "old zshrc"
  assert_file_contents "$TEST_HOME/.config/tmux/tmux.conf" "old tmux"
  assert_file_contents "$TEST_HOME/.config/ditfiles/gitconfig" "old gitconfig"
  assert_file_contents "$TEST_HOME/.config/ditfiles/conf.d/local.gitconfig" "old git module"
  assert_file_contents "$TEST_HOME/.config/ditfiles/gitignore_global" "old gitignore"
  assert_file_contents "$TEST_HOME/.config/starship.toml" "old starship"
  for helper in tnew thelp tlist tgo tkill _tpick ttutor p _platform _clipboard_copy _open _tmux_help; do
    assert_file_contents "$TEST_HOME/.local/bin/$helper" "old $helper"
  done

  if [[ -f "$TEST_HOME/.test_git_include" ]] && grep -Fxq "$TEST_HOME/.config/ditfiles/gitconfig" "$TEST_HOME/.test_git_include"; then
    fail "git include path was not removed"
  fi
}

setup_stubs
seed_existing_files
run_install
verify_install
run_doctor
verify_doctor
verify_idempotent_install
verify_doctor_detects_broken_helper
verify_doctor_path_check_uses_fixed_string
run_uninstall
verify_uninstall
verify_install_handles_parent_directory_conflicts
verify_install_handles_nested_directory_conflicts
verify_install_rejects_unknown_phase
verify_install_links_auto_preflight
verify_uninstall_restores_unmanaged_repo_symlink
verify_uninstall_preserves_user_changes_after_install
verify_uninstall_removes_empty_directories
verify_doctor_accepts_symlinked_repo_path

echo "install/uninstall integration test passed"
