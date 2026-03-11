# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #91 `docs: align ai-init starter guidance with ai-start backend options`
- Branch: `docs/91-ai-init-backend-guidance`
- Memory Artifact: `tasks/sprint-memory/issue-91.md`
- Resume Point: generated starter guidance now reflects tmux default plus stdio alternative; next sprint can move to backend-aware doctor or richer starter surfaces

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Align generated starter guidance with the current `ai start` backend contract so first-run artifacts tell the same story as the runtime docs.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - backend-aware `ai init` starter guidance
  - concrete surfaces
  - [`bin/ai-init`](./bin/ai-init)
  - [`demo/sample-project/.ai-dev-os/README.md`](./demo/sample-project/.ai-dev-os/README.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_init.sh`](./test/ai_init.sh)
  - [`test/demo_assets.sh`](./test/demo_assets.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
  - acceptance slice
  - generated starter README mentions `tmux` as the current default and `stdio` as an alternative
  - `ai init` output mentions the backend-aware `ai start` contract
  - demo starter fixture stays in sync
  - tests guard the new wording

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#91` is the sprint slice for this turn
- Backlog Refinement
  - Task 36 was added and converted into issue `#91`
- Review / Demo
  - show generated starter guidance using tmux default plus stdio alternative
- Retrospective
  - keep generated surfaces aligned immediately after runtime/docs changes

## Verification

- `bash test/demo_assets.sh`
- `bash test/ai_init.sh`
- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - align `ai init` output and generated starter README with `tmux` default plus `stdio` alternative
  - keep the local-first onboarding order unchanged
  - lock the wording with init/demo/structure guards
- Retrospective
  - keep: follow top-level docs with generated-surface alignment in the next sprint
  - change: treat `ai init` output as part of the beginner contract, not just scaffolding noise
  - stop: leaving generated starter artifacts one backend story behind
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - keeping generated starter surfaces aligned with code-level backend changes
- change
  - move generated-surface follow-through into the next sprint after top-level docs land
- stop
  - assuming runtime docs are enough once starter artifacts still say less
