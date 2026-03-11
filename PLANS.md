# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #69 `docs: define a PLANS.md closeout contract for turn-scoped sprints`
- Branch: `docs/69-plans-closeout-contract`
- Memory Artifact: `tasks/sprint-memory/issue-69.md`
- Resume Point: closeout completed for this turn-scoped sprint; next work should start from a new issue-backed sprint

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Define a minimal closeout contract for `PLANS.md` so turn-scoped sprints do not leave stale active-plan metadata behind after merge.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

- primary deliverable
  - a durable `PLANS.md` closeout contract for turn-scoped sprints
- concrete surfaces
  - [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md)
  - [`PLANS.md`](./PLANS.md)
  - [`tasks/sprint-memory/README.md`](./tasks/sprint-memory/README.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
- acceptance slice
  - `docs/93-scrum-delivery.md` defines what `active`, `multi-turn`, and `closed` mean for `PLANS.md`
  - `PLANS.md` shows the closeout shape for a completed sprint
  - sprint-memory guidance explains when `PLANS.md` should point to a memory artifact versus `not needed`

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#69` is the sprint slice for this turn
- Backlog Refinement
  - Task 25 was added and converted into issue `#69`
- Review / Demo
  - show the new closeout fields, memory handoff wording, and guard coverage
- Retrospective
  - keep the closeout contract short enough to avoid heavy archival overhead

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - define a canonical `PLANS.md` closeout contract in [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md)
  - align [`PLANS.md`](./PLANS.md) to the new `Sprint Status` / `Sprint Scope` / `Memory Artifact` / `Resume Point` shape
  - clarify memory handoff wording in [`tasks/sprint-memory/README.md`](./tasks/sprint-memory/README.md)
  - lock the contract with [`test/repository_structure.sh`](./test/repository_structure.sh)
- Retrospective
  - keep: the turn-scoped sprint rule lightweight and grep-guarded
  - change: make plan closeout explicit instead of inferring it from merge state
  - stop: leaving `PLANS.md` in an active-looking state after the sprint is done
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - treating workflow rules as repo artifacts, not just chat habits
- change
  - define closeout fields explicitly instead of relying on implied plan state
- stop
  - leaving merged work behind with a plan that still reads as active
