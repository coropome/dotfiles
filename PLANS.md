# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #85 `adr: define terminal orchestration modes beyond tmux`
- Branch: `docs/85-terminal-orchestration-modes`
- Memory Artifact: `tasks/sprint-memory/issue-85.md`
- Resume Point: terminal-orchestration boundary is fixed; next sprint can implement the workspace backend adapter from a fresh issue-backed branch

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Decide the durable boundary between AI Dev OS as an agent control plane and tmux as the current workspace backend.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - terminal-orchestration boundary ADR and supporting docs
  - concrete surfaces
  - [`docs/adr/0006-terminal-orchestration-modes.md`](./docs/adr/0006-terminal-orchestration-modes.md)
  - [`docs/90-philosophy.md`](./docs/90-philosophy.md)
  - [`docs/91-state-ownership.md`](./docs/91-state-ownership.md)
  - [`docs/31-support-matrix.md`](./docs/31-support-matrix.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
  - acceptance slice
  - ADR defines AI control plane, workspace backend, and terminal-native integration boundaries
  - docs state that tmux is currently required for `ai start`, but is not the north-star product boundary
  - follow-up implementation work is captured in backlog
  - structure tests guard the new ADR and key wording

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#85` is the sprint slice for this turn
- Backlog Refinement
  - Task 33 was added and converted into issue `#85`; Task 34 is the implementation follow-up
- Review / Demo
  - show the new boundary: AI surface first, tmux as current backend, terminal-native frontends as optional integrations
- Retrospective
  - keep architecture decisions ahead of expensive backend rewrites

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - add an ADR that defines tmux as the current workspace backend rather than the AI Dev OS control plane
  - align philosophy, ownership, and support docs with that boundary
  - leave a follow-up backlog task for a future workspace backend adapter
- Retrospective
  - keep: decide long-term boundaries before replacing host-runtime machinery
  - change: separate durable control-plane decisions from current backend defaults
  - stop: letting the current tmux implementation silently define the product boundary
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: updated

## Retrospective

- keep
  - treating host-runtime design as a first-class product decision
- change
  - decide backend boundaries explicitly before chasing terminal trends
- stop
  - treating tmux as part of the north-star product definition just because it is the current implementation
