#!/usr/bin/env bash

need() { command -v "$1" >/dev/null 2>&1; }

ok()   { printf "[OK] %s\n" "$*"; }
ng()   { printf "[NG] %s\n" "$*"; }
info() { printf "[..] %s\n" "$*"; }
warn() { printf "[WARN] %s\n" "$*"; }

show_phase() {
  printf "==> %s\n" "$1"
}

abs_path() {
  local path="$1"
  printf "%s\n" "$(cd "$(dirname "$path")" && pwd -P)/$(basename "$path")"
}

resolve_link_target() {
  local target="$1"
  local link

  link="$(readlink "$target" 2>/dev/null || true)"
  if [[ -z "$link" ]]; then
    return 1
  fi

  if [[ "$link" == /* ]]; then
    printf "%s\n" "$(cd "$(dirname "$link")" && pwd -P)/$(basename "$link")"
  else
    printf "%s\n" "$(cd "$(dirname "$target")" && cd "$(dirname "$link")" && pwd -P)/$(basename "$link")"
  fi
}

same_link_target() {
  local target="$1"
  local expected="$2"
  local actual=""

  actual="$(resolve_link_target "$target" || true)"
  expected="$(abs_path "$expected")"
  [[ -n "$actual" && "$actual" == "$expected" ]]
}

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

git_include_present() {
  local include_path="$1"
  git config --global --get-all include.path 2>/dev/null | grep -Fxq "$include_path"
}

