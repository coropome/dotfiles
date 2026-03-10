#!/usr/bin/env bash

ai_os_linux_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    printf 'apt-get\n'
  elif command -v dnf >/dev/null 2>&1; then
    printf 'dnf\n'
  elif command -v pacman >/dev/null 2>&1; then
    printf 'pacman\n'
  else
    printf '\n'
  fi
}

ai_os_install_packages() {
  local manager
  manager="$(ai_os_linux_pkg_manager)"

  case "$manager" in
    apt-get)
      exec sudo apt-get install -y "$@"
      ;;
    dnf)
      exec sudo dnf install -y "$@"
      ;;
    pacman)
      exec sudo pacman -S --noconfirm "$@"
      ;;
    *)
      echo "no supported Linux package manager found" >&2
      return 1
      ;;
  esac
}

ai_os_install_apps() {
  echo "app installs are not implemented for linux yet" >&2
  return 1
}

ai_os_open() {
  exec xdg-open "$1"
}

ai_os_copy() {
  if command -v wl-copy >/dev/null 2>&1; then
    exec wl-copy
  fi
  if command -v xclip >/dev/null 2>&1; then
    exec xclip -selection clipboard
  fi
  exec xsel --clipboard --input
}
