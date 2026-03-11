# AI Dev OS Plan

- Date: 2026-03-11
- Active issue: #38 `refactor: reduce runtime repo identity coupling in starter guidance and templates`
- Branch: `feat/38-runtime-repo-decoupling`

## MVP

Current newcomer MVP:

- macOS user can run `./install` and `make agent`
- in an existing repo, `ai init` creates a usable local starter without hand editing shell code
- `ai doctor` explains missing binaries, prompt/config gaps, and fallback paths before launch
- `ai workflows` / `ai --help` expose available workflow candidates
- `ai start` opens a working AI Dev OS workspace for that repo
- GitHub Actions starter is optional and can be added or skipped at init time

## Current Goal

Reduce runtime-repo identity coupling in generated starter guidance and GitHub Actions templates while keeping the current default runtime source compatible.

## Acceptance Slice

- generated starter README describes a shared AI Dev OS runtime and the current default runtime source separately
- GitHub Actions starter templates keep default runtime env vars but frame them as overrideable defaults
- docs/42 explains current default runtime source without treating it as product identity
- tests guard the less-coupled wording while preserving the default repo/ref behavior

## Scout Lanes

- Lane A: onboarding/docs scout
  - keep one agent looking for newcomer friction in generated artifacts, quickstart docs, and troubleshooting flow
- Lane B: runtime/doctor scout
  - keep one agent looking for gaps between workflow resolution, fallback behavior, and vendor-native readiness checks
- Lane C: platform scout
  - keep one agent looking for Linux/WSL readiness, portability gaps, and late-failing OS wrappers

## Next Queue

- `refactor: rename DITFILES-specific env/help surfaces that still leak host-era naming`
- `docs/demo: sample-project root README を staged adoption と AI Dev OS-first framing に揃える`
- `refactor: separate runtime-repo docs from adopter-repo troubleshooting more explicitly`
