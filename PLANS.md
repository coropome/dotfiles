# AI Dev OS Plan

- Date: 2026-03-11
- Active issue: #33 `docs/init: keep skip-mode generated README aligned with the default failure and adoption model`
- Branch: `docs/33-skip-mode-readme-parity`

## MVP

Current newcomer MVP:

- macOS user can run `./install` and `make agent`
- in an existing repo, `ai init` creates a usable local starter without hand editing shell code
- `ai doctor` explains missing binaries, prompt/config gaps, and fallback paths before launch
- `ai workflows` / `ai --help` expose available workflow candidates
- `ai start` opens a working AI Dev OS workspace for that repo
- GitHub Actions starter is optional and can be added or skipped at init time

## Current Goal

Keep skip-mode generated READMEs semantically aligned with the default starter README so `--no-github-actions` and `--no-hosted-eval` do not lose the same failure/adoption model.

## Acceptance Slice

- `--no-github-actions` output still explains when to use `ai doctor`, `docs/42-github-actions.md`, and `make doctor`
- `--no-hosted-eval` output still preserves the local-only / PR CI / hosted eval later model
- variant READMEs are not semantically thinner than the default README apart from skipped optional surfaces
- tests cover skip-mode remediation and adoption guidance explicitly

## Scout Lanes

- Lane A: onboarding/docs scout
  - keep one agent looking for newcomer friction in generated artifacts, quickstart docs, and troubleshooting flow
- Lane B: runtime/doctor scout
  - keep one agent looking for gaps between workflow resolution, fallback behavior, and vendor-native readiness checks
- Lane C: platform scout
  - keep one agent looking for Linux/WSL readiness, portability gaps, and late-failing OS wrappers

## Next Queue

- `docs: normalize ai doctor vs make doctor guidance across newcomer docs`
- `feat: deepen ai doctor for vendor-native runtime consistency`
- `docs/demo: sample-project root README を staged adoption と doctor split に揃える`
