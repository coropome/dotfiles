#!/usr/bin/env bash

ai_os_install_packages() {
  ai_os_linux_pkg_manager "$@"
}

ai_os_linux_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    exec sudo apt-get install -y "$@"
  fi
  echo "no supported WSL package manager found" >&2
  return 1
}

ai_os_install_apps() {
  echo "app installs are not implemented for wsl yet" >&2
  return 1
}

ai_os_open() {
  if command -v wslview >/dev/null 2>&1; then
    exec wslview "$1"
  fi
  if command -v explorer.exe >/dev/null 2>&1; then
    exec explorer.exe "$1"
  fi
  if command -v xdg-open >/dev/null 2>&1; then
    exec xdg-open "$1"
  fi
  echo "no supported WSL opener found; install wslu or ensure explorer.exe is available" >&2
  return 1
}

ai_os_copy() {
  if command -v clip.exe >/dev/null 2>&1; then
    exec clip.exe
  fi
  echo "clip.exe not found; run from WSL with Windows integration enabled" >&2
  return 1
}
