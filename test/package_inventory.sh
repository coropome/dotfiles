#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_ROOT"' EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

verify_brewfile_matches_manifest() {
  "$REPO/bin/render-brewfile" > "$TMPDIR_ROOT/Brewfile.rendered"
  diff -u "$REPO/Brewfile" "$TMPDIR_ROOT/Brewfile.rendered" \
    || fail "Brewfile is out of sync with manifests/packages/core-brew.txt"
}

verify_ansible_package_vars_match_manifests() {
  "$REPO/bin/render-ansible-package-vars" > "$TMPDIR_ROOT/packages.yml.rendered"
  diff -u "$REPO/ansible/vars/packages.yml" "$TMPDIR_ROOT/packages.yml.rendered" \
    || fail "ansible/vars/packages.yml is out of sync with package manifests"
}

verify_ansible_playbook_uses_package_vars() {
  mkdir -p "$TMPDIR_ROOT/ansible-local-tmp"
  ANSIBLE_LOCAL_TEMP="$TMPDIR_ROOT/ansible-local-tmp" \
    ansible-playbook \
      -i "$REPO/ansible/inventory/localhost.ini" \
      "$REPO/ansible/macos.yml" \
      --tags brew \
      --list-tasks \
      >/dev/null \
    || fail "ansible/macos.yml failed to resolve package vars at runtime"
}

verify_agent_target_uses_manifest() {
  grep -Fq 'manifests/packages/agent-brew.txt' "$REPO/Makefile" \
    || fail "make agent does not read manifests/packages/agent-brew.txt"
  grep -Fq 'manifests/packages/agent-cask.txt' "$REPO/Makefile" \
    || fail "make agent does not read manifests/packages/agent-cask.txt"
}

verify_brewfile_matches_manifest
verify_ansible_package_vars_match_manifests
verify_ansible_playbook_uses_package_vars
verify_agent_target_uses_manifest

echo "package inventory test passed"
