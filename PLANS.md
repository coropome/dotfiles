# AI Dev OS Plan

- Date: 2026-03-11
- Active issue: #36 `refactor: make AI Dev OS the primary product surface`
- Branch: `feat/36-ai-dev-os-primary-surface`

## MVP

Current newcomer MVP:

- macOS user can run `./install` and `make agent`
- in an existing repo, `ai init` creates a usable local starter without hand editing shell code
- `ai doctor` explains missing binaries, prompt/config gaps, and fallback paths before launch
- `ai workflows` / `ai --help` expose available workflow candidates
- `ai start` opens a working AI Dev OS workspace for that repo
- GitHub Actions starter is optional and can be added or skipped at init time

## Current Goal

Refactor the highest-signal surfaces so AI Dev OS is the primary product framing and dotfiles/bootstrap are described as host substrate.

## Acceptance Slice

- ADR records AI Dev OS as the primary product surface
- README and top-level docs describe AI Dev OS first, with host bootstrap as substrate
- ownership and philosophy docs separate AI Dev OS control plane from host configuration layers
- user-facing CLI and generated starter wording stop referring to this repo as a dotfiles repo
- tests guard the new wording on the most important surfaces

## Scout Lanes

- Lane A: onboarding/docs scout
  - keep one agent looking for newcomer friction in generated artifacts, quickstart docs, and troubleshooting flow
- Lane B: runtime/doctor scout
  - keep one agent looking for gaps between workflow resolution, fallback behavior, and vendor-native readiness checks
- Lane C: platform scout
  - keep one agent looking for Linux/WSL readiness, portability gaps, and late-failing OS wrappers

## Next Queue

- `refactor: reduce runtime repo identity coupling in generated starter guidance and templates`
- `refactor: rename DITFILES-specific env/help surfaces that still leak host-era naming`
- `docs/demo: sample-project root README を staged adoption と AI Dev OS-first framing に揃える`
