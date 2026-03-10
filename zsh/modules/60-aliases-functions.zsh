if [[ "$DITFILES_OS" != "Darwin" ]]; then
  if has_cmd _open; then
    alias open='_open'
  elif has_cmd xdg-open; then
    alias open='xdg-open'
  fi
fi

if [[ "$DITFILES_OS" == "Darwin" ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
alias ll='ls -lah'
alias la='ls -la'

mkcd() {
  mkdir -p "$1" && cd "$1"
}

extract_tar_zst() {
  local archive="$1"

  need_cmd tar "extract: tar not found. Install bsdtar/gnu-tar." || return 1

  if tar --help 2>/dev/null | grep -Fq -- '--zstd'; then
    tar --zstd -xf "$archive"
    return 0
  fi

  if has_cmd unzstd; then
    unzstd -c "$archive" | tar xf -
    return 0
  fi

  if has_cmd zstd; then
    zstd -dc "$archive" | tar xf -
    return 0
  fi

  echo "extract: no .tar.zst extractor found (need tar --zstd, unzstd, or zstd)." >&2
  return 1
}

extract() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: extract <file> [...]" >&2
    return 1
  fi

  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      echo "extract: '$f' not found" >&2
      continue
    fi

    case "$f" in
      *.tar.gz|*.tgz)
        need_cmd tar "extract: tar not found. Install bsdtar/gnu-tar." || continue
        tar xzf "$f"
        ;;
      *.tar.bz2|*.tbz2)
        need_cmd tar "extract: tar not found. Install bsdtar/gnu-tar." || continue
        tar xjf "$f"
        ;;
      *.tar.xz|*.txz)
        need_cmd tar "extract: tar not found. Install bsdtar/gnu-tar." || continue
        tar xJf "$f"
        ;;
      *.tar.zst)
        extract_tar_zst "$f"
        ;;
      *.tar)
        need_cmd tar "extract: tar not found. Install bsdtar/gnu-tar." || continue
        tar xf "$f"
        ;;
      *.gz)
        need_cmd gunzip "extract: gunzip not found. Install gzip." || continue
        gunzip "$f"
        ;;
      *.bz2)
        need_cmd bunzip2 "extract: bunzip2 not found. Install bzip2." || continue
        bunzip2 "$f"
        ;;
      *.xz)
        need_cmd unxz "extract: unxz not found. Install xz." || continue
        unxz "$f"
        ;;
      *.zip)
        need_cmd unzip "extract: unzip not found. Install unzip." || continue
        unzip "$f"
        ;;
      *)
        echo "extract: unsupported format: $f" >&2
        ;;
    esac
  done
}

alias dco='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'

dex() {
  docker exec -it "$1" /bin/bash
}

explain() {
  if ! has_cmd gemini; then
    echo "gemini CLI not found. Run: make agent" >&2
    return 1
  fi

  local prompt="${1:-Explain this output concisely.}"
  if [[ ! -t 0 ]]; then
    gemini "$prompt" <&0
  else
    gemini "$prompt"
  fi
}
