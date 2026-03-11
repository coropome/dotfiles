# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #71 `docs: add a reusable PLANS.md template for turn-scoped and multi-turn sprints`
- Branch: `docs/71-plans-template`
- Memory Artifact: `tasks/sprint-memory/issue-71.md`
- Resume Point: reusable plan template landed; start the next sprint from a new issue-backed branch and refresh `PLANS.md` from the template

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Add a reusable `PLANS.md` template so turn-scoped and intentionally multi-turn sprints start from the canonical shape instead of ad hoc copying.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

- primary deliverable
  - a reusable `PLANS.md` template for turn-scoped and multi-turn sprints
- concrete surfaces
  - [`templates/plans/PLANS.md`](./templates/plans/PLANS.md)
  - [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md)
  - [`PLANS.md`](./PLANS.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
- acceptance slice
  - a reusable plan template exists in the repo
  - the template covers `turn-scoped` and `multi-turn` use
  - `docs/93-scrum-delivery.md` points to the template as the recommended starting shape
  - structure tests guard the template and its canonical fields

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#71` is the sprint slice for this turn
- Backlog Refinement
  - Task 26 was added and converted into issue `#71`
- Review / Demo
  - show the reusable template, docs link, and guard coverage
- Retrospective
  - keep the template small enough to guide, not to become process bloat

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - add [`templates/plans/PLANS.md`](./templates/plans/PLANS.md) as the canonical reusable starting shape
  - connect [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md) to the template for new sprint setup
  - keep [`PLANS.md`](./PLANS.md) and [`test/repository_structure.sh`](./test/repository_structure.sh) aligned with the template contract
- Retrospective
  - keep: turning recurring sprint behavior into reusable repo assets
  - change: give the next sprint a canonical starting file instead of expecting hand-copy from the last plan
  - stop: relying on the previous `PLANS.md` as the only source for a new sprint skeleton
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
  - make the canonical shape easier to start from, not just easier to verify after the fact
- stop
  - depending on hand-copying the previous sprint plan as the only bootstrap path
