#!/usr/bin/env bash

ai_os_install_packages() {
  brew install "$@"
}

ai_os_install_apps() {
  brew install --cask "$@"
}

ai_os_open() {
  exec open "$1"
}

ai_os_copy() {
  exec pbcopy
}
