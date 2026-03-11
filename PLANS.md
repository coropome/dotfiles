# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #105 `chore: refactor ai-doctor runtime status helpers`
- Branch: `chore/105-ai-doctor-runtime-helpers`
- Memory Artifact: `tasks/sprint-memory/issue-105.md`
- Resume Point: ai-doctor now reports runtime config and extension status through helpers; next sprint can either keep tightening shell internals or move into expansion work

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Refactor `ai-doctor` runtime status reporting so the code stays easy to read and extend without changing the current diagnostics contract.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - cleaner `ai-doctor` runtime status reporting
  - concrete surfaces
  - [`bin/ai-doctor`](./bin/ai-doctor)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_doctor.sh`](./test/ai_doctor.sh)
  - acceptance slice
  - `ai-doctor` keeps current runtime-status output unchanged
  - repeated file/directory-backed status reporting moves into clearer helpers
  - tests lock the refactor with at least one explicit filtered-output assertion

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#105` is the sprint slice for this turn
- Backlog Refinement
  - Task 43 was added and converted into issue `#105`
- Review / Demo
  - show `bin/ai-doctor` reading as helper-based runtime status reporting while keeping the same diagnostics
- Retrospective
  - keep shell cleanup moving once user-facing contracts settle

## Verification

- `bash test/ai_doctor.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - refactor `ai-doctor` runtime status reporting into helpers without changing doctor output
  - keep project/user/mcp/extensions diagnostics stable
  - lock the refactor with doctor tests, including filtered-output coverage
- Retrospective
  - keep: use small refactors once product wording has stabilized
  - change: add one extra targeted assertion whenever shell diagnostics are rearranged
  - stop: letting repeated runtime-status reporting keep growing inline
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - cleaning shell diagnostics once outward behavior is stable
- change
  - lock refactors with a targeted filtered-output assertion instead of relying only on broad coverage
- stop
  - allowing runtime-status reporting to keep spreading across repeated blocks
