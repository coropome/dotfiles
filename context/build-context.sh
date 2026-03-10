#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]}"
if [[ -L "$SCRIPT_PATH" ]]; then
  SCRIPT_PATH="$(readlink "$SCRIPT_PATH")"
fi
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd -P)"
DEFAULT_REPO="$(cd "$SCRIPT_DIR/.." && pwd -P)"

usage() {
  cat <<'EOF'
usage: build-context.sh [--repo PATH] [--show|--print-dir]
EOF
}

repo_path="$DEFAULT_REPO"
mode="print-dir"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      [[ $# -ge 2 ]] || { usage >&2; exit 2; }
      repo_path="$2"
      shift 2
      ;;
    --show)
      mode="show"
      shift
      ;;
    --print-dir)
      mode="print-dir"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
done

if git -C "$repo_path" rev-parse --show-toplevel >/dev/null 2>&1; then
  repo_root="$(git -C "$repo_path" rev-parse --show-toplevel)"
else
  repo_root="$(cd "$repo_path" && pwd -P)"
fi

context_dir="$repo_root/.context"
summary_file="$context_dir/summary.md"
files_file="$context_dir/file-structure.txt"
commits_file="$context_dir/recent-commits.txt"
important_file="$context_dir/important-files.txt"
repo_name="$(basename "$repo_root")"

mkdir -p "$context_dir"

branch_name="unavailable"
if git -C "$repo_root" rev-parse --show-toplevel >/dev/null 2>&1; then
  branch_name="$(git -C "$repo_root" branch --show-current 2>/dev/null || true)"
  if [[ -z "$branch_name" ]]; then
    branch_name="$(git -C "$repo_root" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
  fi
  [[ -n "$branch_name" ]] || branch_name="detached"
fi

{
  printf "# Repository Summary\n\n"
  printf -- "- name: %s\n" "$repo_name"
  printf -- "- path: %s\n" "$repo_root"
  printf -- "- branch: %s\n" "$branch_name"
  printf "\n## Key Paths\n\n"
  find "$repo_root" -mindepth 1 -maxdepth 1 \( -type d -o -type f \) \
    ! -name .git ! -name .context \
    -exec basename {} \; | sort | head -20 | sed 's#^#- #'
} > "$summary_file"

if command -v rg >/dev/null 2>&1; then
  (cd "$repo_root" && rg --files . | sed 's#^\./##' | head -200) > "$files_file"
else
  (cd "$repo_root" && find . -type f | sed 's#^\./##' | sort | head -200) > "$files_file"
fi

if git -C "$repo_root" rev-parse --show-toplevel >/dev/null 2>&1; then
  git -C "$repo_root" log --oneline -5 > "$commits_file" 2>/dev/null || : > "$commits_file"
else
  : > "$commits_file"
fi

{
  if [[ -f "$repo_root/README.md" ]]; then
    printf 'README.md\n'
  fi
  if [[ -f "$repo_root/Makefile" ]]; then
    printf 'Makefile\n'
  fi
  if [[ -d "$repo_root/bin" ]]; then
    printf 'bin/\n'
  fi
  if [[ -d "$repo_root/src" ]]; then
    printf 'src/\n'
  fi
  if [[ -d "$repo_root/app" ]]; then
    printf 'app/\n'
  fi
  if [[ -d "$repo_root/tests" ]]; then
    printf 'tests/\n'
  fi
} > "$important_file"

case "$mode" in
  show)
    cat "$summary_file"
    ;;
  print-dir)
    printf "%s\n" "$context_dir"
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
