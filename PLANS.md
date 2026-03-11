# AI Dev OS Plan

- Date: 2026-03-11
- Active issue: #42 `docs: make demo sample-project README follow staged AI Dev OS adoption`
- Branch: `docs/42-demo-readme-staged-adoption`

## MVP

Current newcomer MVP:

- macOS user can run `./install` and `make agent`
- in an existing repo, `ai init` creates a usable local starter without hand editing shell code
- `ai doctor` explains missing binaries, prompt/config gaps, and fallback paths before launch
- `ai workflows` / `ai --help` expose available workflow candidates
- `ai start` opens a working AI Dev OS workspace for that repo
- GitHub Actions starter is optional and can be added or skipped at init time

## Current Goal

Make the demo sample-project README a top-level staged AI Dev OS adoption entrypoint aligned with the walkthrough and generated starter semantics.

## Acceptance Slice

- `demo/sample-project/README.md` explains the local-first staged adoption flow
- the demo README points to `ai doctor`, `ai workflows`, and `ai start` in order
- CI/runtime guidance remains secondary and points back to the runtime repo doc split
- walkthrough and demo tests stay aligned with the new README

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
