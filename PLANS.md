# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #93 `docs: make ai-doctor next steps backend-aware`
- Branch: `docs/93-ai-doctor-backend-guidance`
- Memory Artifact: `tasks/sprint-memory/issue-93.md`
- Resume Point: ai-doctor next steps now reflect tmux default plus stdio alternative; next sprint can tighten troubleshooting or move to richer backend surfaces

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Align `ai doctor` next steps with the current `ai start` backend contract so recovery surfaces tell the same story as launch surfaces.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - backend-aware `ai doctor` next steps
  - concrete surfaces
  - [`bin/ai-doctor`](./bin/ai-doctor)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_doctor.sh`](./test/ai_doctor.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
  - acceptance slice
  - healthy and warn doctor outputs mention the stdio ai-start alternative
  - fail-case guidance stays focused on fixing reported gaps first
  - docs explain the backend-aware doctor footer
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
  - issue `#93` is the sprint slice for this turn
- Backlog Refinement
  - Task 37 was added and converted into issue `#93`
- Review / Demo
  - show ai-doctor healthy/warn next steps using tmux default plus stdio alternative
- Retrospective
  - keep recovery surfaces aligned right after launch-surface changes

## Verification

- `bash test/ai_doctor.sh`
- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - align ai-doctor healthy/warn next steps with `tmux` default plus `stdio` alternative
  - keep the fail case focused on fixing reported gaps first
  - lock the wording with doctor and structure guards
- Retrospective
  - keep: follow launch-surface changes with recovery-surface alignment in the next sprint
  - change: treat ai-doctor footer lines as part of the backend contract once they become guidance
  - stop: leaving doctor output on an older single-path story
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - keeping recovery surfaces aligned with code-level backend changes
- change
  - move recovery follow-through into the next sprint after launch surfaces land
- stop
  - assuming launch docs are enough once doctor still says less
