# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #73 `feat: teach ai task to summarize pending backlog work before printing the backlog`
- Branch: `feat/73-ai-task-pending-summary`
- Memory Artifact: `tasks/sprint-memory/issue-73.md`
- Resume Point: ai-task summary upgrade landed; next sprint should start from a new issue-backed branch and refresh this plan from the template

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Make `ai task` a better backlog-refinement entrypoint by showing pending work first without losing the full backlog output.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

- primary deliverable
  - a pending-summary upgrade for `ai task`
- concrete surfaces
  - [`bin/ai-task`](./bin/ai-task)
  - [`bin/ai`](./bin/ai)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`PLANS.md`](./PLANS.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
- acceptance slice
  - `ai task` prints a pending summary before the full backlog
  - the summary includes task number and title for pending tasks
  - `ai task` says when there are no pending tasks
  - help/docs wording reflects summary-plus-backlog behavior

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#73` is the sprint slice for this turn
- Backlog Refinement
  - Task 27 was added and converted into issue `#73`
- Review / Demo
  - show the pending summary, no-pending fallback, and full backlog preservation
- Retrospective
  - keep `ai task` lightweight and text-only; do not turn it into an interactive task manager

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - prepend pending-task summary output in [`bin/ai-task`](./bin/ai-task) while preserving the full backlog body
  - update [`bin/ai`](./bin/ai) and [`docs/40-cli.md`](./docs/40-cli.md) so `ai task` reads as a backlog-refinement entrypoint
  - cover pending and no-pending cases, plus summary/body ordering, in [`test/ai_cli.sh`](./test/ai_cli.sh)
- Retrospective
  - keep: improving operator entrypoints without adding a new command surface
  - change: test behavior against fixed backlog fixtures instead of the live repo backlog state
  - stop: relying on raw file dumps for daily backlog refinement
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
  - improve operator entrypoints after the planning substrate is stable
- stop
  - treating `ai task` as a raw file dump when backlog refinement is now part of the operating model
