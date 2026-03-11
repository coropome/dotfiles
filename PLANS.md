# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #103 `chore: refactor ai-start backend handling into helpers`
- Branch: `chore/103-ai-start-backend-helpers`
- Memory Artifact: `tasks/sprint-memory/issue-103.md`
- Resume Point: ai-start now routes backend validation, stop, launch, and attach behavior through helpers; next sprint can either keep polishing shell internals or shift fully into expansion work

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Refactor `ai-start` backend handling so the code stays easy to read and extend without changing the current tmux/stdio contract.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - cleaner `ai-start` backend orchestration
  - concrete surfaces
  - [`bin/ai-start`](./bin/ai-start)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
  - acceptance slice
  - `ai-start` keeps the current tmux/stdio behavior unchanged
  - backend validation, stop, launch, and attach logic move into clearer helpers
  - tests lock the refactor with at least one explicit edge-case assertion

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#103` is the sprint slice for this turn
- Backlog Refinement
  - Task 42 was added and converted into issue `#103`
- Review / Demo
  - show `bin/ai-start` reading as helper-based orchestration while keeping the same tmux/stdio behavior
- Retrospective
  - keep code cleanup moving once the surface-level contract settles

## Verification

- `bash test/ai_cli.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - refactor `ai-start` into backend helpers without changing the tmux/stdio contract
  - keep help, start, stop, attach, and failure behavior stable
  - lock the refactor with CLI tests, including the unknown-backend path
- Retrospective
  - keep: use small refactors once product wording has stabilized
  - change: add one extra edge-case assertion when refactoring shell control flow
  - stop: leaving backend branching to grow linearly inside one script body
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - cleaning shell control flow once outward behavior is stable
- change
  - lock refactors with a targeted edge-case assertion instead of relying only on happy-path coverage
- stop
  - allowing backend orchestration logic to keep spreading across repeated case blocks
