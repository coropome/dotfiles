#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
requirements_file="$repo_root/ansible/requirements.yml"
inventory_file="$repo_root/ansible/inventory/localhost.ini"
playbook_file="$repo_root/ansible/macos.yml"
local_vars_file="$repo_root/ansible/local.yml"
if [[ -f "$repo_root/lib/bootstrap/common.sh" ]]; then
  source "$repo_root/lib/bootstrap/common.sh"
else
  need() { command -v "$1" >/dev/null 2>&1; }
  info() { printf "[..] %s\n" "$*"; }
  show_phase() { printf "==> %s\n" "$1"; }
  require_darwin() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
      echo "This repo is Mac-only (Darwin)." >&2
      return 1
    fi
  }
  require_homebrew() {
    if ! need brew; then
      echo "Homebrew not found. Install: https://brew.sh" >&2
      return 1
    fi
  }
  require_xcode_clt() {
    if ! xcode-select -p >/dev/null 2>&1; then
      echo "Xcode Command Line Tools not found. Run: xcode-select --install" >&2
      return 1
    fi
  }
  phase_selected() {
    local desired="$1"
    local phase
    for phase in "${SELECTED_PHASES[@]}"; do
      if [[ "$phase" == "$desired" ]]; then
        return 0
      fi
    done
    return 1
  }
fi

usage() {
  cat <<'EOF'
Usage: ./ansible/run.sh [--phase <name>]... [ansible-playbook args...]

Phases:
  preflight   verify macOS/Homebrew and install ansible if needed
  collections install required ansible collections
  playbook    run ansible-playbook with forwarded args

Default: run all phases in the order above.
Custom `collections` / `playbook` runs automatically prepend `preflight`.
EOF
}

VALID_PHASES=(preflight collections playbook)
SELECTED_PHASES=()
PLAYBOOK_ARGS=()
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
      PLAYBOOK_ARGS+=("$1")
      shift
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
  if ! phase_selected preflight; then
    SELECTED_PHASES=(preflight "${SELECTED_PHASES[@]}")
  fi
}

if [[ ${#SELECTED_PHASES[@]} -eq 0 ]]; then
  SELECTED_PHASES=(preflight collections playbook)
else
  validate_selected_phases
  ensure_required_preflight
fi

run_ansible_preflight() {
  show_phase "Running Ansible preflight..."
  require_darwin
  require_homebrew
  require_xcode_clt

  if ! need ansible-playbook; then
    info "Installing ansible via Homebrew..."
    brew install ansible
  fi
}

ensure_collections() {
  show_phase "Ensuring Ansible collections..."
  ansible-galaxy collection install -r "$requirements_file" >/dev/null
}

run_playbook() {
  local cmd=(ansible-playbook -i "$inventory_file" "$playbook_file")

  if [[ -f "$local_vars_file" ]]; then
    cmd+=(-e "@$local_vars_file")
  fi
  cmd+=("${PLAYBOOK_ARGS[@]}")

  show_phase "Running ansible-playbook..."
  "${cmd[@]}"
}

phase_selected preflight && run_ansible_preflight
phase_selected collections && ensure_collections
phase_selected playbook && run_playbook
