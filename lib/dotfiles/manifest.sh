#!/usr/bin/env bash

# Utilities for reading simple line and TSV manifests.

dotfiles_manifest_lines() {
  local manifest_path="$1"

  [[ -f "$manifest_path" ]] || return 1

  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" ]] && continue
    [[ "$line" == \#* ]] && continue
    printf "%s\n" "$line"
  done < "$manifest_path"
}

dotfiles_manifest_tsv_rows() {
  local manifest_path="$1"

  [[ -f "$manifest_path" ]] || return 1

  while IFS=$'\t' read -r -a columns || [[ ${#columns[@]} -gt 0 ]]; do
    [[ ${#columns[@]} -eq 0 ]] && continue
    [[ -z "${columns[0]}" ]] && continue
    [[ "${columns[0]}" == \#* ]] && continue
    printf "%s\n" "${columns[*]}"
  done < "$manifest_path"
}
