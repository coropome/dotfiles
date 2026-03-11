# AI Dev OS Plan

- Date: 2026-03-11
- Active issue: #40 `refactor: add AI Dev OS env aliases for user-facing overrides`
- Branch: `feat/40-ai-dev-os-env-aliases`

## MVP

Current newcomer MVP:

- macOS user can run `./install` and `make agent`
- in an existing repo, `ai init` creates a usable local starter without hand editing shell code
- `ai doctor` explains missing binaries, prompt/config gaps, and fallback paths before launch
- `ai workflows` / `ai --help` expose available workflow candidates
- `ai start` opens a working AI Dev OS workspace for that repo
- GitHub Actions starter is optional and can be added or skipped at init time

## Current Goal

Add AI Dev OS env aliases for user-facing override variables while keeping `DITFILES_*` as backward-compatible fallbacks.

## Acceptance Slice

- `bin/p` prefers `AI_DEV_OS_PROJECT_ROOTS` and `AI_DEV_OS_PROJECT_MAX_DEPTH` while keeping fallback support
- editor override logic accepts `AI_DEV_OS_EDITOR` and `AI_DEV_OS_FORCE_VIM`
- newcomer docs recommend `AI_DEV_OS_*` names for new configs and note backward compatibility
- tests cover alias precedence and compatibility behavior

## Scout Lanes

- Lane A: onboarding/docs scout
  - keep one agent looking for newcomer friction in generated artifacts, quickstart docs, and troubleshooting flow
- Lane B: runtime/doctor scout
  - keep one agent looking for gaps between workflow resolution, fallback behavior, and vendor-native readiness checks
- Lane C: platform scout
  - keep one agent looking for Linux/WSL readiness, portability gaps, and late-failing OS wrappers

## Next Queue

- `docs/demo: sample-project root README を staged adoption と AI Dev OS-first framing に揃える`
- `refactor: separate runtime-repo docs from adopter-repo troubleshooting more explicitly`
- `refactor: rename remaining DITFILES-specific internal/help surfaces after user-facing aliases settle`
