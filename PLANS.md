# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #113 `chore: refactor ai-doctor control flow helpers`
- Branch: `chore/113-ai-doctor-control-helpers`
- Memory Artifact: `tasks/sprint-memory/issue-113.md`
- Resume Point: ai-doctor now routes filter validation, section printing, and warn/fail bookkeeping through helpers; next sprint can keep tightening shell internals or move into expansion work

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Refactor `ai-doctor` control flow so the code stays easy to read and extend without changing the current reporting and next-step contracts.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - cleaner `ai-doctor` reporting control flow
  - concrete surfaces
  - [`bin/ai-doctor`](./bin/ai-doctor)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_doctor.sh`](./test/ai_doctor.sh)
  - acceptance slice
  - `ai-doctor` keeps current reporting and next-step behavior unchanged
  - filter validation, section printing, and warn/fail bookkeeping move into clearer helpers
  - tests lock the refactor with an explicit unknown-workflow assertion

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#113` is the sprint slice for this turn
- Backlog Refinement
  - Task 47 was added and converted into issue `#113`
- Review / Demo
  - show `bin/ai-doctor` reading as helper-based reporting flow while keeping the same diagnostics and next steps
- Retrospective
  - keep shell cleanup moving once user-facing contracts settle

## Verification

- `bash test/ai_cli.sh`
- `bash test/ai_doctor.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - refactor `ai-doctor` control flow into helpers without changing reporting behavior
  - keep unknown-filter recovery and next-step guidance stable
  - lock the refactor with doctor tests, including explicit unknown-workflow coverage
- Retrospective
  - keep: use small refactors once product wording has stabilized
  - change: add one explicit recovery-path assertion whenever report control flow is rearranged
  - stop: letting ai-doctor keep mixing printing and global-state mutation inline
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - cleaning heavy shell reporting surfaces once outward behavior is stable
- change
  - lock refactors with a targeted recovery assertion instead of relying only on broad coverage
- stop
  - allowing ai-doctor validation, section printing, and state updates to keep spreading across one control path
