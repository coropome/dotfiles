#!/usr/bin/env bash
set -euo pipefail

# resolve repo root regardless of where this script is called from
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$REPO/lib/bootstrap/common.sh"
source "$REPO/lib/bootstrap/manifest.sh"

usage() {
  cat <<'EOF'
Usage: ./install.sh [--phase <name>]...

Phases:
  preflight  verify host prerequisites
  packages   install core Homebrew dependencies
  backup     back up managed files before relinking
  links      link shell, tmux, git, and prompt config
  git        configure git include state
  helpers    link helper commands into ~/.local/bin
  plugins    install or update tmux plugins
  verify     verify managed bootstrap state

Default: run all phases in the order above.
Mutating partial runs automatically prepend `preflight`.
EOF
}

VALID_PHASES=(preflight packages backup links git helpers plugins verify)
MUTATING_PHASES=(packages backup links git helpers plugins)
SELECTED_PHASES=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --phase)
      if [[ $# -lt 2 || -z "${2:-}" ]]; then
        echo "error: --phase requires a value" >&2
        exit 2
      fi
      SELECTED_PHASES+=("$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown arg: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

phase_is_valid() {
  local candidate="$1"
  local phase

  for phase in "${VALID_PHASES[@]}"; do
    if [[ "$phase" == "$candidate" ]]; then
      return 0
    fi
  done

  return 1
}

validate_selected_phases() {
  local phase

  for phase in "${SELECTED_PHASES[@]}"; do
    if ! phase_is_valid "$phase"; then
      echo "unknown phase: $phase" >&2
      usage >&2
      exit 2
    fi
  done
}

ensure_required_preflight() {
  local phase

  if phase_selected preflight; then
    return 0
  fi

  for phase in "${MUTATING_PHASES[@]}"; do
    if phase_selected "$phase"; then
      SELECTED_PHASES=(preflight "${SELECTED_PHASES[@]}")
      return 0
    fi
  done
}

if [[ ${#SELECTED_PHASES[@]} -eq 0 ]]; then
  SELECTED_PHASES=(preflight packages backup links git helpers plugins verify)
else
  validate_selected_phases
  ensure_required_preflight
fi

# --- backups ---
TS="$(date +%Y%m%d-%H%M%S)"
backup_one() {
  local target="$1"
  local expected="${2:-}"
  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -n "$expected" ]] && same_link_target "$target" "$expected"; then
      return 0
    fi
    mv "$target" "${target}.bak.${TS}"
    echo "  Backed up: $target -> ${target}.bak.${TS}"
  fi
}

ensure_dir() {
  local target="$1"
  if [[ ( -e "$target" || -L "$target" ) && ! -d "$target" ]]; then
    backup_one "$target"
  fi
  mkdir -p "$target"
}

ensure_external_dir() {
  local target="$1"
  if [[ -e "$target" && ! -d "$target" ]]; then
    echo "$target exists and is not a directory. Move it aside and rerun make install." >&2
    exit 1
  fi
  mkdir -p "$target"
}

ensure_git_checkout() {
  local label="$1"
  local repo_url="$2"
  local target_dir="$3"

  if [[ -d "$target_dir/.git" ]]; then
    show_phase "Updating $label..."
    git -C "$target_dir" pull --ff-only >/dev/null
  elif [[ -e "$target_dir" ]]; then
    echo "$label directory exists but is not a git checkout: $target_dir" >&2
    exit 1
  else
    show_phase "Installing $label..."
    git clone "$repo_url" "$target_dir" >/dev/null
  fi
}

ensure_tpm_plugins() {
  ensure_external_dir "$HOME/.tmux"
  ensure_external_dir "$HOME/.tmux/plugins"
  while IFS='|' read -r label repo_url target_dir _binary; do
    ensure_git_checkout "$label" "$repo_url" "$target_dir"
  done < <(tmux_plugin_specs)
}

backup_managed_targets() {
  show_phase "Backing up existing dotfiles..."
  while IFS='|' read -r target expected _mode; do
    backup_one "$target" "$expected"
  done < <(managed_link_specs)
}

ensure_managed_directories() {
  ensure_dir "$HOME/.config"
  ensure_dir "$HOME/.config/tmux"
  ensure_dir "$HOME/.config/ditfiles"
  ensure_dir "$HOME/.local"
  ensure_dir "$HOME/.local/bin"
}

link_spec() {
  local target="$1"
  local source="$2"
  ln -sfn "$source" "$target"
}

link_managed_configs() {
  show_phase "Symlinking shell, tmux, git, and prompt config..."
  ensure_managed_directories
  while IFS='|' read -r target source _mode; do
    link_spec "$target" "$source"
  done < <(managed_config_specs)
}

configure_git_state() {
  local gitconfig_path="$HOME/.config/ditfiles/gitconfig"

  show_phase "Setting up git config..."
  if ! git_include_present "$gitconfig_path"; then
    git config --global --add include.path "$gitconfig_path"
  fi
  if ! git_include_present "$gitconfig_path"; then
    echo "Failed to add git include.path for $gitconfig_path" >&2
    exit 1
  fi
}

link_helper_commands() {
  show_phase "Installing helper commands (tnew, tgo, ...)..."
  ensure_dir "$HOME/.local"
  ensure_dir "$HOME/.local/bin"
  while IFS='|' read -r target source _mode; do
    link_spec "$target" "$source"
  done < <(managed_helper_specs)
}

verify_link_state() {
  local failures=0

  while IFS='|' read -r target expected required_mode; do
    if [[ ! -L "$target" ]]; then
      ng "$target is not linked"
      failures=1
      continue
    fi
    if ! same_link_target "$target" "$expected"; then
      ng "$target does not point to $expected"
      failures=1
      continue
    fi
    if [[ "$required_mode" == "executable" && ! -x "$expected" ]]; then
      ng "$expected is not executable"
      failures=1
      continue
    fi
    ok "$target"
  done < <(managed_link_specs)

  return "$failures"
}

verify_plugin_state() {
  local failures=0

  while IFS='|' read -r label _repo_url target_dir binary_path; do
    if [[ -n "$binary_path" ]]; then
      if [[ ! -x "$target_dir/$binary_path" ]]; then
        ng "$label missing ($target_dir/$binary_path)"
        failures=1
        continue
      fi
    elif [[ ! -d "$target_dir" ]]; then
      ng "$label missing ($target_dir)"
      failures=1
      continue
    fi
    ok "$label"
  done < <(tmux_plugin_specs)

  return "$failures"
}

run_install_verification() {
  local failures=0
  local gitconfig_path="$HOME/.config/ditfiles/gitconfig"

  show_phase "Verifying bootstrap state..."
  verify_link_state || failures=1
  if git_include_present "$gitconfig_path"; then
    ok "git include.path ($gitconfig_path)"
  else
    ng "git include.path missing ($gitconfig_path)"
    failures=1
  fi
  verify_plugin_state || failures=1

  if [[ "$failures" -ne 0 ]]; then
    echo "Bootstrap verification failed." >&2
    exit 1
  fi
}

if phase_selected preflight; then
  show_phase "Running bootstrap preflight..."
  require_darwin
  require_homebrew
  require_xcode_clt
fi

if phase_selected packages; then
  show_phase "Installing packages via Homebrew (may take a few minutes)..."
  brew bundle --file "$REPO/Brewfile"
fi

phase_selected backup && backup_managed_targets
phase_selected links && link_managed_configs
phase_selected git && configure_git_state
phase_selected helpers && link_helper_commands

if phase_selected plugins; then
  show_phase "Installing tmux plugins..."
  ensure_tpm_plugins
fi

phase_selected verify && run_install_verification

echo ""
echo "Done! Backups saved as *.bak.$TS (only when existing files were found)"
echo ""
echo "Next steps:"
echo "  1. Open a new terminal  (zshrc changes take effect in a new shell)"
echo "  2. Run: tnew"
echo "  3. After a reboot, tmux sessions auto-restore when you start tmux again"
