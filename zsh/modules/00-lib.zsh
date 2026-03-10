autoload -Uz colors && colors

DITFILES_OS="$(uname -s)"

has_cmd() {
  (( $+commands[$1] ))
}

need_cmd() {
  if ! has_cmd "$1"; then
    echo "${2:-$1 not found}" >&2
    return 1
  fi
}

ditfiles_brew_prefix() {
  if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
    printf '%s\n' "$HOMEBREW_PREFIX"
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    printf '%s\n' /opt/homebrew
  elif [[ -x /usr/local/bin/brew ]]; then
    printf '%s\n' /usr/local
  elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    printf '%s\n' /home/linuxbrew/.linuxbrew
  elif has_cmd brew; then
    brew --prefix 2>/dev/null || true
  else
    printf '\n'
  fi
}

ditfiles_source_first_existing() {
  local candidate

  for candidate in "$@"; do
    if [[ -f "$candidate" ]]; then
      source "$candidate"
      return 0
    fi
  done

  return 1
}

ditfiles_source_all_existing() {
  local candidate
  local sourced=1

  for candidate in "$@"; do
    if [[ -f "$candidate" ]]; then
      source "$candidate"
      sourced=0
    fi
  done

  return "$sourced"
}
