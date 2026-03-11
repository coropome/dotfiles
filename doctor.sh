#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$REPO/lib/bootstrap/common.sh"
source "$REPO/lib/bootstrap/manifest.sh"

check_link() {
  local target="$1"
  local expected="$2"
  local required_mode="${3:-}"
  local actual=""

  if [[ ! -e "$target" && ! -L "$target" ]]; then
    ng "$target missing ($bootstrap_hint)"
    return
  fi
  if [[ ! -L "$target" ]]; then
    ng "$target exists but is not a symlink ($bootstrap_hint)"
    return
  fi

  actual="$(resolve_link_target "$target" || true)"
  expected="$(abs_path "$expected")"
  if [[ "$actual" != "$expected" ]]; then
    ng "$target points to ${actual:-?} (expected $expected; $bootstrap_hint)"
    return
  fi

  if [[ ! -e "$actual" ]]; then
    ng "$target points to missing target $actual ($bootstrap_hint)"
    return
  fi

  if [[ "$required_mode" == "executable" && ! -x "$actual" ]]; then
    ng "$target points to non-executable target $actual (run: chmod +x $actual)"
    return
  fi

  ok "$target"
}

ver() {
  local cmd="$1"
  $cmd --version 2>/dev/null | head -1 \
    || $cmd version 2>/dev/null | head -1 \
    || echo "?"
}

git_config_get() {
  git config --global --get "$1" 2>/dev/null || true
}

git_config_get_includes() {
  git config --global --includes --get "$1" 2>/dev/null || true
}

expand_home_path() {
  local path="$1"

  case "$path" in
    \~)
      printf "%s\n" "$HOME"
      ;;
    \~/*)
      printf "%s/%s\n" "$HOME" "${path#~/}"
      ;;
    *)
      printf "%s\n" "$path"
      ;;
  esac
}

kernel_release() {
  uname -r 2>/dev/null || true
}

proc_version() {
  if [[ -n "${DITFILES_TEST_PROC_VERSION:-}" ]]; then
    printf '%s\n' "$DITFILES_TEST_PROC_VERSION"
    return 0
  fi

  cat /proc/version 2>/dev/null || true
}

platform_variant() {
  if [[ "$platform_name" == "Darwin" ]]; then
    printf 'mac\n'
    return 0
  fi

  if [[ "$platform_name" == "Linux" ]]; then
    if [[ "$(kernel_release)" == *Microsoft* || "$(proc_version)" == *Microsoft* ]]; then
      printf 'wsl\n'
      return 0
    fi
    printf 'linux\n'
    return 0
  fi

  printf 'other\n'
}

check_platform_wrapper_readiness() {
  local variant="$1"
  local opener=""
  local clipboard=""

  echo ""
  echo "--- platform wrappers ---"

  case "$variant" in
    mac)
      info "ai-open: uses macOS open"
      info "ai-copy: uses macOS pbcopy"
      ;;
    linux)
      if command -v xdg-open >/dev/null 2>&1; then
        opener="$(command -v xdg-open)"
        ok "ai-open backend: xdg-open ($opener)"
      else
        ng "ai-open backend missing: xdg-open (install xdg-utils on Linux)"
      fi

      if command -v wl-copy >/dev/null 2>&1; then
        clipboard="$(command -v wl-copy)"
        ok "ai-copy backend: wl-copy ($clipboard)"
      elif command -v xclip >/dev/null 2>&1; then
        clipboard="$(command -v xclip)"
        ok "ai-copy backend: xclip ($clipboard)"
      elif command -v xsel >/dev/null 2>&1; then
        clipboard="$(command -v xsel)"
        ok "ai-copy backend: xsel ($clipboard)"
      else
        ng "ai-copy backend missing: install wl-copy, xclip, or xsel on Linux"
      fi
      ;;
    wsl)
      if command -v wslview >/dev/null 2>&1; then
        opener="$(command -v wslview)"
        ok "ai-open backend: wslview ($opener)"
      elif command -v explorer.exe >/dev/null 2>&1; then
        opener="$(command -v explorer.exe)"
        ok "ai-open backend: explorer.exe ($opener)"
      elif command -v xdg-open >/dev/null 2>&1; then
        opener="$(command -v xdg-open)"
        warn "ai-open backend fallback: xdg-open ($opener; install wslu for wslview if you want native Windows handoff)"
      else
        ng "ai-open backend missing: install wslu for wslview or ensure explorer.exe is available in WSL"
      fi

      if command -v clip.exe >/dev/null 2>&1; then
        clipboard="$(command -v clip.exe)"
        ok "ai-copy backend: clip.exe ($clipboard)"
      else
        ng "ai-copy backend missing: clip.exe (run from WSL with Windows integration enabled)"
      fi
      ;;
    *)
      info "platform wrapper readiness: no dedicated checks for $platform_name"
      ;;
  esac
}

platform_name="$(uname -s)"
platform_variant_name="$(platform_variant)"

if [[ "$platform_variant_name" == "mac" ]]; then
  bootstrap_hint="run: make install"
  package_hint="run: make mac"
  agent_cli_hint="run: make agent"
  ok "macOS"
  info "macOS version: $(sw_vers -productVersion 2>/dev/null || echo '?')"
else
  bootstrap_hint="manual bootstrap on non-macOS; see docs/31-support-matrix.md"
  package_hint="manual package setup on non-macOS; see docs/31-support-matrix.md"
  agent_cli_hint="manual agent setup on non-macOS; see docs/31-support-matrix.md"
  warn "not macOS (bootstrap is macOS-first; doctor is best-effort here)"
  info "platform: $platform_name"
  [[ "$platform_variant_name" == "wsl" ]] && info "platform variant: WSL"
fi
info "arch: $(uname -m)"

echo ""
echo "--- core tools ---"
for c in brew zsh tmux git; do
  if command -v "$c" >/dev/null 2>&1; then
    ok "$c $(ver "$c")  ($(command -v "$c"))"
  else
    ng "$c not found ($bootstrap_hint)"
  fi
done

# AI agent runtimes
for c in node npm python3 uv; do
  if command -v "$c" >/dev/null 2>&1; then
    ok "$c $(ver "$c")  ($(command -v "$c"))"
  else
    ng "$c not found ($package_hint)"
  fi
done

# AI agent CLIs
if command -v claude >/dev/null 2>&1; then
  ok "claude: $(command -v claude)"
else
  ng "claude not found ($agent_cli_hint)"
fi

if command -v gemini >/dev/null 2>&1; then
  ok "gemini: $(command -v gemini)"
else
  ng "gemini not found ($agent_cli_hint)"
fi

if command -v codex >/dev/null 2>&1; then
  ok "codex: $(command -v codex)"
else
  ng "codex not found ($agent_cli_hint)"
fi

# core extras (used by gitconfig / lint)
for c in delta shellcheck; do
  if command -v "$c" >/dev/null 2>&1; then
    ok "$c $(ver "$c")  ($(command -v "$c"))"
  else
    ng "$c not found ($bootstrap_hint)"
  fi
done

# brew health
if command -v brew >/dev/null 2>&1; then
  info "brew prefix: $(brew --prefix)"
  if brew doctor >/dev/null 2>&1; then
    ok "brew doctor: OK"
  else
    ng "brew doctor: issues (run: brew doctor)"
  fi
fi

# Xcode Command Line Tools
if [[ "$platform_name" == "Darwin" ]]; then
  if xcode-select -p >/dev/null 2>&1; then
    ok "xcode-select: $(xcode-select -p)"
  else
    ng "Xcode Command Line Tools not found (run: xcode-select --install)"
  fi
else
  info "xcode-select: skipped on non-macOS"
fi

# PATH hints
if ! echo ":$PATH:" | grep -Fq ":$HOME/.local/bin:"; then
  ng "$HOME/.local/bin not in PATH (zshrc should add it)"
else
  ok "$HOME/.local/bin in PATH"
fi

check_platform_wrapper_readiness "$platform_variant_name"

echo ""
echo "--- dotfiles links ---"
while IFS='|' read -r target expected required_mode; do
  check_link "$target" "$expected" "$required_mode"
done < <(managed_link_specs)

echo ""
echo "--- git layer ---"
git_include_path="$HOME/.config/ditfiles/gitconfig"
git_include_count="$(git config --global --get-all include.path 2>/dev/null | grep -Fxc "$git_include_path" || true)"

if [[ "$git_include_count" -eq 1 ]]; then
  ok "git include.path registered"
elif [[ "$git_include_count" -gt 1 ]]; then
  warn "git include.path duplicated ($git_include_count entries for $git_include_path)"
else
  ng "git include.path missing ($bootstrap_hint)"
fi

git_core_pager="$(git_config_get_includes core.pager)"
if [[ "$git_core_pager" == "delta" ]]; then
  ok "git core.pager (delta)"
else
  warn "git core.pager not effective (expected delta)"
fi

git_excludes_file="$(git_config_get_includes core.excludesfile)"
if [[ "$git_excludes_file" == \~/.config/ditfiles/gitignore_global ]]; then
  ok "git excludesFile (~/.config/ditfiles/gitignore_global)"
else
  warn "git excludesFile not effective (expected ~/.config/ditfiles/gitignore_global)"
fi

git_credential_helper="$(git_config_get credential.helper)"
case "$git_credential_helper" in
  "")
    info "git credential.helper not set"
    ;;
  store)
    warn "git credential.helper=store persists secrets in plaintext; prefer OS keychain helpers"
    ;;
  *)
    info "git credential.helper is user-managed ($git_credential_helper)"
    ;;
esac

git_commit_signing="$(git_config_get commit.gpgsign)"
if [[ "$git_commit_signing" == "true" ]]; then
  git_signing_format="$(git_config_get gpg.format)"
  git_signing_key="$(git_config_get user.signingkey)"

  if [[ -z "$git_signing_key" ]]; then
    warn "git commit signing enabled but user.signingkey is unset"
  elif [[ "$git_signing_format" == "ssh" ]]; then
    git_signing_key_path="$(expand_home_path "$git_signing_key")"
    if [[ -f "$git_signing_key_path" ]]; then
      ok "git ssh signing key ($git_signing_key)"
    else
      warn "git ssh signing key missing ($git_signing_key)"
    fi
  else
    info "git commit signing enabled"
  fi
else
  info "git commit signing: optional (see docs/03-git.md)"
fi

echo ""
echo "--- tmux persistence ---"
while IFS='|' read -r label _repo_url target_dir binary_path; do
  if [[ -n "$binary_path" ]]; then
    if [[ -x "$target_dir/$binary_path" ]]; then
      ok "$label ($target_dir/$binary_path)"
    else
      ng "$label not found ($bootstrap_hint)"
    fi
  elif [[ -d "$target_dir" ]]; then
    ok "$label"
  else
    ng "$label not found ($bootstrap_hint; or prefix + I inside tmux on supported setups)"
  fi
done < <(tmux_plugin_specs)
info "session restore: restart tmux after reboot to reload saved sessions"

echo ""
echo "--- shell enhancements (used by zshrc) ---"
# fzf and starship are in Brewfile (make install), the rest in make mac
for c in fzf starship; do
  if command -v "$c" >/dev/null 2>&1; then
    ok "$c $(ver "$c")"
  else
    ng "$c not found ($bootstrap_hint)"
  fi
done
for c in eza bat zoxide; do
  if command -v "$c" >/dev/null 2>&1; then
    ok "$c $(ver "$c")"
  else
    ng "$c not found ($package_hint)"
  fi
done

# zsh plugins via brew
_brew_prefix="$(brew --prefix 2>/dev/null || :)"
for plugin in \
  "zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
do
  if [[ -n "$_brew_prefix" && -f "$_brew_prefix/share/$plugin" ]]; then
    ok "${plugin%%/*}"
  else
    ng "${plugin%%/*} not found ($bootstrap_hint)"
  fi
done

# Proxy hints (corp)
for k in HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY http_proxy https_proxy all_proxy no_proxy; do
  v="${!k:-}"
  [[ -n "$v" ]] && info "$k is set"
done

# ditfiles local override
if [[ -f "$HOME/.config/ditfiles/local.zsh" ]]; then
  ok "local overrides: ~/.config/ditfiles/local.zsh present"
else
  info "local overrides: (optional) create ~/.config/ditfiles/local.zsh for company/proxy settings"
fi

if command -v ansible-galaxy >/dev/null 2>&1; then
  if ansible-galaxy collection list community.general 2>/dev/null | grep -Fq "community.general"; then
    ok "ansible collection: community.general"
  else
    ng "ansible collection missing: community.general (run: ./ansible/run.sh --phase collections)"
  fi
fi
