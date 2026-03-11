#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_exists() {
  local path="$1"
  [[ -e "$path" || -L "$path" ]] || fail "missing: $path"
}

assert_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "expected file: $path"
}

assert_dir() {
  local path="$1"
  [[ -d "$path" ]] || fail "expected directory: $path"
}

assert_executable() {
  local path="$1"
  [[ -x "$path" ]] || fail "expected executable: $path"
}

assert_symlink_target() {
  local path="$1"
  local expected="$2"
  [[ -L "$path" ]] || fail "expected symlink: $path"
  [[ "$(readlink "$path")" == "$expected" ]] || fail "$path points to $(readlink "$path"), expected $expected"
}

verify_links_manifest() {
  local manifest="$REPO/manifests/bootstrap/links.tsv"
  local line target source type source_path
  local -a targets=()

  assert_file "$manifest"

  while IFS=$'\t' read -r target source type || [[ -n "${target:-}" ]]; do
    [[ -z "${target:-}" || "${target:0:1}" == "#" ]] && continue

    source_path="$REPO/$source"
    case "$type" in
      file)
        assert_file "$source_path"
        ;;
      executable)
        assert_file "$source_path"
        assert_executable "$source_path"
        ;;
      directory)
        assert_dir "$source_path"
        ;;
      *)
        fail "unknown link type '$type' in $manifest"
        ;;
    esac

    targets+=("$target")
  done < "$manifest"

  if [[ ${#targets[@]} -eq 0 ]]; then
    fail "no managed links found in $manifest"
  fi

  line="$(printf '%s\n' "${targets[@]}" | sort | uniq -d | head -1 || true)"
  [[ -z "$line" ]] || fail "duplicate managed link target in manifest: $line"
}

verify_helper_inventory() {
  local manifest="$REPO/manifests/helpers.txt"
  local helper
  local -a helpers=()
  local required

  assert_file "$manifest"
  while IFS= read -r helper || [[ -n "${helper:-}" ]]; do
    [[ -z "${helper:-}" || "${helper:0:1}" == "#" ]] && continue
    assert_executable "$REPO/bin/$helper"
    helpers+=("$helper")
  done < "$manifest"

  [[ ${#helpers[@]} -gt 0 ]] || fail "no helpers found in $manifest"

  for required in ai ai-init ai-start ai-agent ai-context ai-doctor ai-task ai-eval ai-trust ai-install ai-copy ai-open; do
    printf '%s\n' "${helpers[@]}" | grep -Fxq "$required" \
      || fail "missing helper '$required' in $manifest"
  done
}

verify_tmux_plugin_manifest() {
  local manifest="$REPO/manifests/tmux/plugins.tsv"
  local name repo_url target_dir _binary_path
  local -a plugins=()

  assert_file "$manifest"
  while IFS=$'\t' read -r name repo_url target_dir _binary_path || [[ -n "${name:-}" ]]; do
    [[ -z "${name:-}" || "${name:0:1}" == "#" ]] && continue
    [[ -n "$repo_url" ]] || fail "missing repo_url for plugin '$name'"
    [[ -n "$target_dir" ]] || fail "missing target_dir for plugin '$name'"
    plugins+=("$name")
  done < "$manifest"

  [[ ${#plugins[@]} -eq 3 ]] || fail "expected 3 tmux plugins, found ${#plugins[@]}"
  assert_dir "$REPO/tmux/conf.d"
}

verify_git_layout() {
  assert_file "$REPO/git/gitconfig"
  assert_file "$REPO/git/gitignore_global"
  assert_dir "$REPO/git/conf.d"
  assert_file "$REPO/git/conf.d/00-core.gitconfig"
  assert_file "$REPO/git/conf.d/10-delta.gitconfig"
  assert_file "$REPO/git/conf.d/20-workflow.gitconfig"
  assert_file "$REPO/git/conf.d/90-aliases.gitconfig"
}

verify_tmux_compatibility_hooks() {
  local copy_mode_conf="$REPO/tmux/conf.d/40-copy-mode.conf"
  local key_conf="$REPO/tmux/conf.d/30-keys.conf"
  local plugin_bootstrap_conf="$REPO/tmux/conf.d/99-plugin-bootstrap.conf"

  assert_file "$copy_mode_conf"
  assert_file "$key_conf"
  assert_file "$plugin_bootstrap_conf"
  grep -Fq "\$HOME/.local/bin/_clipboard_copy" "$copy_mode_conf" \
    || fail "tmux copy mode does not use the managed clipboard adapter"
  grep -Fq "\$HOME/.local/bin/_tmux_help" "$key_conf" \
    || fail "tmux help bindings do not use the managed compatibility helper"
  grep -Fq 'if-shell' "$plugin_bootstrap_conf" \
    || fail "tmux plugin bootstrap is not guarded"
}

verify_package_manifests() {
  local manifest line duplicate

  for manifest in \
    "$REPO/manifests/packages/core-brew.txt" \
    "$REPO/manifests/packages/macos-brew.txt" \
    "$REPO/manifests/packages/macos-cask.txt" \
    "$REPO/manifests/packages/agent-brew.txt" \
    "$REPO/manifests/packages/agent-cask.txt"
  do
    assert_file "$manifest"
    line="$(grep -Ev '^\s*(#|$)' "$manifest" | head -1 || true)"
    [[ -n "$line" ]] || fail "empty package manifest: $manifest"
    duplicate="$(grep -Ev '^\s*(#|$)' "$manifest" | sort | uniq -d | head -1 || true)"
    [[ -z "$duplicate" ]] || fail "duplicate entry '$duplicate' in $manifest"
  done
}

verify_layout_scaffold() {
  assert_file "$REPO/install"
  assert_file "$REPO/AGENTS.md"
  assert_exists "$REPO/CLAUDE.md"
  assert_exists "$REPO/GEMINI.md"
  assert_symlink_target "$REPO/CLAUDE.md" "AGENTS.md"
  assert_symlink_target "$REPO/GEMINI.md" "AGENTS.md"
  assert_executable "$REPO/install"
  assert_dir "$REPO/ai"
  assert_dir "$REPO/os"
  assert_dir "$REPO/prompts"
  assert_dir "$REPO/context"
  assert_dir "$REPO/tasks"
  assert_dir "$REPO/.github"
  assert_dir "$REPO/.github/ISSUE_TEMPLATE"
  assert_dir "$REPO/demo/sample-project"
  assert_dir "$REPO/demo/sample-project/.ai-dev-os"
  assert_dir "$REPO/demo/sample-project/.github"
  assert_dir "$REPO/demo/sample-project/.github/workflows"
  assert_dir "$REPO/demo/sample-project/.ai-dev-os/prompts"
  assert_dir "$REPO/docs/adr"
  assert_dir "$REPO/lib/bootstrap"
  assert_dir "$REPO/lib/dotfiles"
  assert_dir "$REPO/manifests/bootstrap"
  assert_dir "$REPO/manifests/packages"
  assert_dir "$REPO/manifests/tmux"
  assert_dir "$REPO/templates/github-actions"
  assert_dir "$REPO/templates/ai-trust"
  assert_dir "$REPO/zsh/modules"
  assert_dir "$REPO/tmux/conf.d"
  assert_file "$REPO/ai/agents.yml"
  assert_file "$REPO/ai/workflows.yml"
  assert_file "$REPO/os/mac.sh"
  assert_file "$REPO/os/linux.sh"
  assert_file "$REPO/os/wsl.sh"
  assert_file "$REPO/prompts/architect.md"
  assert_file "$REPO/prompts/implementer.md"
  assert_file "$REPO/prompts/reviewer.md"
  assert_file "$REPO/prompts/researcher.md"
  assert_file "$REPO/prompts/review.prompt.yml"
  assert_file "$REPO/demo/sample-project/README.md"
  assert_file "$REPO/demo/sample-project/.ai-dev-os/agents.yml"
  assert_file "$REPO/demo/sample-project/.ai-dev-os/workflows.yml"
  assert_file "$REPO/demo/sample-project/.ai-dev-os/README.md"
  assert_file "$REPO/demo/sample-project/.github/workflows/ai-dev-os-pr.yml"
  assert_file "$REPO/demo/sample-project/.github/workflows/ai-dev-os-hosted-eval.yml"
  assert_file "$REPO/demo/sample-project/.ai-dev-os/prompts/implementer.md"
  assert_file "$REPO/demo/sample-project/.ai-dev-os/prompts/reviewer.md"
  assert_file "$REPO/demo/sample-project/.ai-dev-os/prompts/review.prompt.yml"
  assert_file "$REPO/templates/github-actions/ai-dev-os-pr.yml"
  assert_file "$REPO/templates/github-actions/ai-dev-os-hosted-eval.yml"
  assert_file "$REPO/templates/ai-trust/claude-settings.json"
  assert_file "$REPO/templates/ai-trust/codex-config.toml"
  assert_file "$REPO/templates/ai-trust/gemini-settings.json"
  assert_file "$REPO/.github/ISSUE_TEMPLATE/feature.yml"
  assert_file "$REPO/.github/ISSUE_TEMPLATE/bug.yml"
  assert_file "$REPO/.github/ISSUE_TEMPLATE/config.yml"
  assert_file "$REPO/.github/copilot-instructions.md"
  assert_file "$REPO/.github/pull_request_template.md"
  assert_file "$REPO/context/build-context.sh"
  assert_executable "$REPO/context/build-context.sh"
  assert_file "$REPO/tasks/backlog.md"
  assert_dir "$REPO/tasks/sprint-memory"
  assert_file "$REPO/tasks/sprint-memory/README.md"
  assert_file "$REPO/docs/92-development-workflow.md"
  assert_file "$REPO/docs/93-scrum-delivery.md"
  assert_file "$REPO/docs/adr/README.md"
  assert_file "$REPO/docs/adr/0001-ai-dev-os-delivery-workflow.md"
  assert_file "$REPO/docs/adr/0002-ai-dev-os-primary-surface.md"
  assert_file "$REPO/docs/adr/0003-ai-dev-os-scrum-cadence.md"
  assert_file "$REPO/docs/adr/0004-ai-dev-os-retro-memory-loop.md"
  assert_file "$REPO/docs/adr/0005-turn-scoped-sprint-cadence.md"
  assert_file "$REPO/docs/05-demo-walkthrough.md"
  assert_file "$REPO/docs/41-ai-trust.md"
  assert_file "$REPO/docs/42-github-actions.md"
  assert_file "$REPO/tmux/layout.conf"
}

verify_ai_dev_os_docs() {
  grep -Fq "# AI Dev OS" "$REPO/README.md" \
    || fail "README.md does not present AI Dev OS as the top-level product surface"
  grep -Fq "AI workspace platform" "$REPO/README.md" \
    || fail "README.md does not describe the repo as an AI workspace platform"
  grep -Fq "ai start" "$REPO/README.md" \
    || fail "README.md does not mention ai start"
  grep -Fq "./install" "$REPO/README.md" \
    || fail "README.md does not contain the OSS quickstart install path"
  grep -Fq "Beginner path" "$REPO/README.md" \
    || fail "README.md does not distinguish the beginner path"
  grep -Fq "Advanced / manual path" "$REPO/README.md" \
    || fail "README.md does not distinguish the advanced path"
  grep -Fq "ai start" "$REPO/docs/00-quickstart.md" \
    || fail "docs/00-quickstart.md does not mention ai start"
  grep -Fq "ai init" "$REPO/docs/00-quickstart.md" \
    || fail "docs/00-quickstart.md does not mention ai init"
  grep -Fq "./install" "$REPO/docs/00-quickstart.md" \
    || fail "docs/00-quickstart.md does not mention ./install"
  grep -Fq "Beginner Path" "$REPO/docs/00-quickstart.md" \
    || fail "docs/00-quickstart.md does not have a beginner path section"
  grep -Fq "Advanced Path" "$REPO/docs/00-quickstart.md" \
    || fail "docs/00-quickstart.md does not have an advanced path section"
  grep -Fq "make agent" "$REPO/docs/99-troubleshooting.md" \
    || fail "docs/99-troubleshooting.md does not cover missing agent CLIs"
  grep -Fq "## AI Dev OS Starter Repos" "$REPO/docs/99-troubleshooting.md" \
    || fail "docs/99-troubleshooting.md does not have an AI Dev OS starter repo section"
  grep -Fq "ai doctor" "$REPO/docs/99-troubleshooting.md" \
    || fail "docs/99-troubleshooting.md does not mention ai doctor"
  grep -Fq "make doctor" "$REPO/docs/99-troubleshooting.md" \
    || fail "docs/99-troubleshooting.md does not mention make doctor"
  grep -Fq "ai trust init" "$REPO/docs/99-troubleshooting.md" \
    || fail "docs/99-troubleshooting.md does not mention ai trust remediation"
  grep -Fq ".ai-dev-os/workflows.yml" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not document .ai-dev-os/workflows.yml"
  grep -Fq "ai init" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not document ai init"
  grep -Fq ".claude/settings.json" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not document vendor-native config boundaries"
  grep -Fq "ai eval" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not document ai eval"
  grep -Fq "ai trust" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not document ai trust"
  grep -Fq "ai init" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not document ai init"
  grep -Fq "AI_DEV_OS_PROJECT_ROOTS" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not document AI Dev OS project root aliases"
  grep -Fq "prompt_file" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not explain role metadata"
  grep -Fq "templates/ai-trust/" "$REPO/docs/40-cli.md" \
    || fail "docs/40-cli.md does not mention trust templates"
  grep -Fq "project-only" "$REPO/docs/41-ai-trust.md" \
    || fail "docs/41-ai-trust.md does not document trust defaults"
  grep -Fq "ai trust init" "$REPO/docs/41-ai-trust.md" \
    || fail "docs/41-ai-trust.md does not document ai trust commands"
  grep -Fq "## Troubleshooting" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not have a troubleshooting section"
  grep -Fq "## Which Path To Choose" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not have an adoption decision guide"
  grep -Fq "AI_DEV_OS_RUNTIME_REF" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not mention runtime pinning"
  grep -Fq "current default source" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not describe the current default runtime source"
  grep -Fq "local-only で始めたい" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not keep the local-only path guidance"
  grep -Fq "PR で最低限の smoke check を回したい" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not keep the PR CI path guidance"
  grep -Fq "hosted eval も使いたい" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not keep the hosted eval path guidance"
  grep -Fq "upstream default branch 追従で困っていない間は不要" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not explain when runtime pinning is unnecessary"
  grep -Fq "fork を使う時、branch で runtime を試す時、upstream drift を止めたい時" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not explain when runtime pinning is recommended"
  grep -Fq "generated CI が upstream の変更で急に揺れた" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not cover upstream drift troubleshooting"
  grep -Fq "fork した runtime を使いたい" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not cover fork runtime troubleshooting"
  grep -Fq "branch で runtime を試したい" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not cover branch runtime troubleshooting"
  grep -Fq "fixed tag / fixed branch / commit-ish に pin する" "$REPO/docs/42-github-actions.md" \
    || fail "docs/42-github-actions.md does not cover fixed-ref stability guidance"
  grep -Fq "AGENTS.md" "$REPO/docs/92-development-workflow.md" \
    || fail "docs/92-development-workflow.md does not mention AGENTS.md"
  grep -Fq "backlog refinement" "$REPO/docs/92-development-workflow.md" \
    || fail "docs/92-development-workflow.md does not mention backlog refinement"
  grep -Fq "retrospective" "$REPO/docs/92-development-workflow.md" \
    || fail "docs/92-development-workflow.md does not mention retrospective"
  grep -Fq "tasks/sprint-memory/" "$REPO/docs/92-development-workflow.md" \
    || fail "docs/92-development-workflow.md does not mention compressed sprint memory"
  grep -Fq "Sprint Planning" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not have a Sprint Planning section"
  grep -Fq "1 往復 = 1 sprint" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the turn-scoped sprint default"
  grep -Fq "intentionally turn をまたぐ" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the multi-turn exception"
  grep -Fq "Backlog Refinement" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not have a Backlog Refinement section"
  grep -Fq "Review / Demo" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not have a Review / Demo section"
  grep -Fq "Retrospective" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not have a Retrospective section"
  grep -Fq "Retrospective Feedback Loop" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the retrospective feedback loop"
  grep -Fq "Sprint Memory" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define sprint memory"
  grep -Fq "Definition of Ready" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define Definition of Ready"
  grep -Fq "Definition of Done" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define Definition of Done"
  grep -Fq "single-step の小さな変更" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not keep the small-change ceremony carve-out"
  grep -Fq "Product / Backlog" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the Product / Backlog role"
  grep -Fq "Delivery / Scrum" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the Delivery / Scrum role"
  grep -Fq "Reviewer / QA" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the Reviewer / QA role"
  grep -Fq "複数 role を兼務してよい" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not allow one person to hold multiple roles"
  grep -Fq "review/demo evidence exists" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not keep review/demo evidence in Definition of Done"
  grep -Fq "retrospective note for the sprint exists" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not keep the retrospective note in Definition of Done"
  grep -Fq "backlog, plans, docs, tests, instructions, ADR, or explicit no-op" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not map retrospective output to system updates"
  grep -Fq "tasks/sprint-memory/issue-<id>.md" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the compressed memory artifact location"
  grep -Fq "tasks/sprint-memory/raw/issue-<id>.md" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the optional raw log location"
  grep -Fq "System Updates" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define system updates"
  grep -Fq "PLANS.md" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not connect Scrum cadence to PLANS.md"
  grep -Fq "PLANS Closeout Contract" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the PLANS closeout contract"
  grep -Fq "Sprint Status" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define sprint status in PLANS.md"
  grep -Fq "## Closeout" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the PLANS closeout section"
  grep -Fq "not needed in this sprint" "$REPO/docs/93-scrum-delivery.md" \
    || fail "docs/93-scrum-delivery.md does not define the no-artifact closeout wording"
  grep -Fq "docs/93-scrum-delivery.md" "$REPO/PLANS.md" \
    || fail "PLANS.md does not point to docs/93-scrum-delivery.md"
  grep -Fq "Sprint Status" "$REPO/PLANS.md" \
    || fail "PLANS.md does not define a sprint status field"
  grep -Fq "Sprint Scope" "$REPO/PLANS.md" \
    || fail "PLANS.md does not define a sprint scope field"
  grep -Fq "Memory Artifact" "$REPO/PLANS.md" \
    || fail "PLANS.md does not define a memory artifact field"
  grep -Fq "Resume Point" "$REPO/PLANS.md" \
    || fail "PLANS.md does not define a resume point field"
  grep -Fq "tasks/sprint-memory/" "$REPO/PLANS.md" \
    || fail "PLANS.md does not point to tasks/sprint-memory/"
  grep -Fq "## Closeout" "$REPO/PLANS.md" \
    || fail "PLANS.md does not define a closeout section"
  grep -Fq "AI Dev OS" "$REPO/docs/90-philosophy.md" \
    || fail "docs/90-philosophy.md does not use the AI Dev OS framing"
  grep -Fq "AI Dev OS control plane" "$REPO/docs/91-state-ownership.md" \
    || fail "docs/91-state-ownership.md does not describe the AI Dev OS control plane boundary"
  grep -Fq "AI_DEV_OS_EDITOR" "$REPO/docs/61-local-customization.md" \
    || fail "docs/61-local-customization.md does not recommend AI Dev OS editor aliases"
  grep -Fq "primary product surface" "$REPO/docs/adr/0002-ai-dev-os-primary-surface.md" \
    || fail "docs/adr/0002-ai-dev-os-primary-surface.md does not record the AI Dev OS product-surface decision"
  grep -Fq "lightweight Scrum cadence" "$REPO/docs/adr/0003-ai-dev-os-scrum-cadence.md" \
    || fail "docs/adr/0003-ai-dev-os-scrum-cadence.md does not record the Scrum cadence decision"
  grep -Fq "small changes" "$REPO/docs/adr/0003-ai-dev-os-scrum-cadence.md" \
    || fail "docs/adr/0003-ai-dev-os-scrum-cadence.md does not keep the small-change escape hatch"
  grep -Fq "compressed sprint memory" "$REPO/docs/adr/0004-ai-dev-os-retro-memory-loop.md" \
    || fail "docs/adr/0004-ai-dev-os-retro-memory-loop.md does not record the compressed sprint memory decision"
  grep -Fq "one user/assistant round-trip as one sprint" "$REPO/docs/adr/0005-turn-scoped-sprint-cadence.md" \
    || fail "docs/adr/0005-turn-scoped-sprint-cadence.md does not record the turn-scoped sprint decision"
  grep -Fq "Compressed Memory" "$REPO/tasks/sprint-memory/README.md" \
    || fail "tasks/sprint-memory/README.md does not define compressed memory"
  grep -Fq "System Updates" "$REPO/tasks/sprint-memory/README.md" \
    || fail "tasks/sprint-memory/README.md does not define system updates"
  grep -Fq "Memory Artifact: tasks/sprint-memory/issue-<id>.md" "$REPO/tasks/sprint-memory/README.md" \
    || fail "tasks/sprint-memory/README.md does not define the canonical memory artifact handoff"
  grep -Fq "Memory Artifact: not needed in this sprint" "$REPO/tasks/sprint-memory/README.md" \
    || fail "tasks/sprint-memory/README.md does not define the no-artifact handoff wording"
  grep -Fq "do not implement without a GitHub Issue" "$REPO/.github/copilot-instructions.md" \
    || fail ".github/copilot-instructions.md does not enforce issue-first work"
  grep -Fq "Likely System Updates" "$REPO/.github/ISSUE_TEMPLATE/feature.yml" \
    || fail ".github/ISSUE_TEMPLATE/feature.yml does not prompt for likely system updates"
  grep -Fq "Sprint Shape / Lanes" "$REPO/.github/ISSUE_TEMPLATE/feature.yml" \
    || fail ".github/ISSUE_TEMPLATE/feature.yml does not prompt for sprint shape"
  grep -Fq "Likely Fix Surfaces" "$REPO/.github/ISSUE_TEMPLATE/bug.yml" \
    || fail ".github/ISSUE_TEMPLATE/bug.yml does not prompt for likely fix surfaces"
  grep -Fq "Sprint Shape / Scope" "$REPO/.github/ISSUE_TEMPLATE/bug.yml" \
    || fail ".github/ISSUE_TEMPLATE/bug.yml does not prompt for sprint scope"
  grep -Fq "docs/93-scrum-delivery.md" "$REPO/AGENTS.md" \
    || fail "AGENTS.md does not point to docs/93-scrum-delivery.md"
  grep -Fq "docs/93-scrum-delivery.md" "$REPO/.github/copilot-instructions.md" \
    || fail ".github/copilot-instructions.md does not point to docs/93-scrum-delivery.md"
  grep -Fq "tasks/sprint-memory/" "$REPO/AGENTS.md" \
    || fail "AGENTS.md does not point to tasks/sprint-memory/"
  grep -Fq "one user/assistant round-trip as one sprint" "$REPO/AGENTS.md" \
    || fail "AGENTS.md does not define the turn-scoped sprint default"
  grep -Fq "tasks/sprint-memory/" "$REPO/.github/copilot-instructions.md" \
    || fail ".github/copilot-instructions.md does not point to tasks/sprint-memory/"
  grep -Fq "one user/assistant round-trip as one sprint" "$REPO/.github/copilot-instructions.md" \
    || fail ".github/copilot-instructions.md does not define the turn-scoped sprint default"
  grep -Fq "Sprint Memory" "$REPO/.github/pull_request_template.md" \
    || fail ".github/pull_request_template.md does not prompt for sprint memory"
  grep -Fq "Review / Demo" "$REPO/.github/pull_request_template.md" \
    || fail ".github/pull_request_template.md does not prompt for review/demo evidence"
  grep -Fq "System Updates" "$REPO/.github/pull_request_template.md" \
    || fail ".github/pull_request_template.md does not prompt for system updates"
  grep -Fq "n/a (small change)" "$REPO/.github/pull_request_template.md" \
    || fail ".github/pull_request_template.md does not preserve the small-change escape hatch"
  grep -Fq "docs/05-demo-walkthrough.md" "$REPO/README.md" \
    || fail "README.md does not link to the demo walkthrough"
}

verify_doctor_guidance_consistency() {
  grep -Fq 'ai doctor` で workflow / prompt / trust / fallback / runtime config' "$REPO/README.md" \
    || fail "README.md does not keep the canonical ai doctor guidance"
  grep -Fq 'make doctor` で host bootstrap / symlink / PATH / shell / system state' "$REPO/README.md" \
    || fail "README.md does not keep the canonical make doctor guidance"
  grep -Fq "workflow / prompt / trust / fallback / runtime config なら \`ai doctor\`" "$REPO/docs/00-quickstart.md" \
    || fail "docs/00-quickstart.md does not keep the canonical ai doctor guidance"
  grep -Fq "host bootstrap / symlink / PATH / shell / system state なら \`make doctor\`" "$REPO/docs/00-quickstart.md" \
    || fail "docs/00-quickstart.md does not keep the canonical make doctor guidance"
  grep -Fq "workflow / prompt / trust / fallback / runtime config を見る時は \`make doctor\` ではなく \`ai doctor\`" "$REPO/docs/31-support-matrix.md" \
    || fail "docs/31-support-matrix.md does not keep the canonical ai doctor guidance"
  grep -Fq "workflow / prompt / trust / fallback / runtime config を診断する" "$REPO/docs/99-troubleshooting.md" \
    || fail "docs/99-troubleshooting.md does not keep the canonical ai doctor guidance"
  grep -Fq "host bootstrap / symlink / PATH / shell / system state を見る" "$REPO/docs/99-troubleshooting.md" \
    || fail "docs/99-troubleshooting.md does not keep the canonical make doctor guidance"
  grep -Fq "docs/42-github-actions.md" "$REPO/docs/99-troubleshooting.md" \
    || fail "docs/99-troubleshooting.md does not point CI/runtime issues to docs/42-github-actions.md"
  grep -Fq "fork / branch / tag pinning と local onboarding failure を分けて考える" "$REPO/docs/99-troubleshooting.md" \
    || fail "docs/99-troubleshooting.md does not preserve CI/runtime vs local onboarding separation"
}

verify_layout_scaffold
verify_links_manifest
verify_helper_inventory
verify_tmux_plugin_manifest
verify_git_layout
verify_tmux_compatibility_hooks
verify_package_manifests
verify_ai_dev_os_docs
verify_doctor_guidance_consistency

echo "repository structure test passed"
