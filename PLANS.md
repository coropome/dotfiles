# AI Dev OS Plan

- Date: 2026-03-11
- Active issue: #42 `docs: make demo sample-project README follow staged AI Dev OS adoption`
- Branch: `docs/42-demo-readme-staged-adoption`

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## MVP

Current newcomer MVP:

- macOS user can run `./install` and `make agent`
- in an existing repo, `ai init` creates a usable local starter without hand editing shell code
- `ai doctor` explains missing binaries, prompt/config gaps, and fallback paths before launch
- `ai workflows` / `ai --help` expose available workflow candidates
- `ai start` opens a working AI Dev OS workspace for that repo
- GitHub Actions starter is optional and can be added or skipped at init time

## Current Goal

Finish the staged-adoption docs pack so the demo fixture, generated starter, quickstart, CLI reference, troubleshooting, and GitHub Actions guidance all tell the same newcomer-first story without losing the deeper daily-tool path.

## Acceptance Slice

- `demo/sample-project/README.md` explains the local-first staged adoption flow
- the demo README points to `ai doctor`, `ai workflows`, and `ai start` in order
- CI/runtime guidance remains secondary and points back to the runtime repo doc split
- walkthrough and demo tests stay aligned with the new README

## Delivery Shape

- primary deliverable
  - a newcomer-first, durable docs narrative for AI Dev OS
- concrete surfaces
  - root README and quickstart
  - generated starter README from `ai init`
  - demo walkthrough and demo fixture README
  - CLI reference for beginner surface vs deeper surface
  - GitHub Actions / troubleshooting split for later lanes
- review contract
  - `ai doctor` is the first diagnostic step
  - `ai workflows` / `ai-agent --describe` are discovery and deep-inspection steps
  - CI, hosted eval, and runtime pinning stay optional later lanes
  - docs and tests preserve the same failure model across surfaces

## PR Shape

- suggested title
  - `docs: align AI Dev OS around a durable local-first adoption path`
- issue links
  - `Closes #42`
  - `Refs #23`
  - `Refs #27`
  - `Refs #29`
  - `Refs #32`
- summary bullets
  - align demo README and walkthrough around `ai doctor` first staged adoption
  - align generated starter guidance and `ai init` next steps around `ai doctor -> ai workflows -> ai start`
  - align README, quickstart, CLI, and philosophy around a durable daily-tool north star
  - keep GitHub Actions, hosted eval, and runtime pinning as later lanes instead of the main path
  - add order-based regression guards so docs do not drift back into a flat checklist
- verification bullets
  - `bash test/ai_init.sh`
  - `bash test/demo_assets.sh`
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`

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
