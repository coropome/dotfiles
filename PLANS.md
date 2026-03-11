# AI Dev OS Plan

- Date: 2026-03-11
- Active issue: #49 `docs: establish a Scrum operating cadence for AI Dev OS delivery`
- Branch: `docs/49-scrum-delivery-cadence`

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Make Scrum-style delivery a durable repo rule instead of an implicit habit, so backlog refinement, sprint commitment, review/demo, and retrospective are all documented and restartable.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- keep `PLANS.md` restartable throughout the sprint
- do backlog refinement before pulling the next non-trivial item
- end the sprint with review/demo evidence and a retrospective note

## Sprint Slice

- primary deliverable
  - a durable Scrum operating guide for AI Dev OS delivery
- concrete surfaces
  - [`docs/92-development-workflow.md`](./docs/92-development-workflow.md)
  - [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md)
  - [`docs/adr/0003-ai-dev-os-scrum-cadence.md`](./docs/adr/0003-ai-dev-os-scrum-cadence.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
- acceptance slice
  - sprint planning, backlog refinement, review/demo, and retrospective are explicit
  - recommended squad roles and skill coverage are explicit
  - current plan references the Scrum guide instead of free-form execution

## Squad

- Product / Backlog: Codex
  - owns issue shape, acceptance criteria, and backlog refinement
- Delivery / Scrum: Codex
  - owns sprint commitment, plan hygiene, and ceremony completion
- Docs / Onboarding: Avicenna
  - scans newcomer clarity and docs cohesion
- Review / QA: Mendel
  - scans regressions, test coverage, and wording drift

Specialists can be added per sprint when needed:

- Runtime / Trust specialist
- Platform / OS specialist
- Prompt / Eval specialist

## Current Sprint Ceremonies

- Sprint Planning
  - commit only issue-backed slices that fit in one focused sprint
- Backlog Refinement
  - convert the next likely improvement into a backlog item with a crisp problem and impact
- Review / Demo
  - leave proof in tests, diff shape, and PR summary
- Retrospective
  - capture what to keep, change, and stop before the next sprint starts

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Retrospective

- keep
  - backlog -> issue -> branch の順で切ってから squad を組む流れ
- change
  - lightweight process の escape hatch は最初から明文化する
- stop
  - ceremony を暗黙知のまま期待する進め方

## Retrospective

- keep
  - tie new operating rules to grep-based structure tests so they do not silently disappear
- change
  - update `PLANS.md` earlier when the slice changes, so the active issue and squad stay correct without a catch-up edit
- stop
  - treating coordination, refinement, and review as implicit behavior instead of explicit repo rules
