# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #109 `chore: refactor top-level ai dispatch helpers`
- Branch: `chore/109-ai-dispatch-helpers`
- Memory Artifact: `tasks/sprint-memory/issue-109.md`
- Resume Point: top-level ai dispatch now routes through direct-command, workflow-alias, and unknown-command helpers; next sprint can keep tightening shell internals or move into expansion work

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Refactor the top-level `ai` entrypoint so the code stays easy to read and extend without changing the current command behavior contract.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - cleaner top-level `ai` dispatch flow
  - concrete surfaces
  - [`bin/ai`](./bin/ai)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
  - acceptance slice
  - top-level `ai` keeps current direct command and workflow alias behavior unchanged
  - direct dispatch, workflow alias dispatch, and unknown-command recovery move into clearer helpers
  - tests lock the refactor with an explicit unknown-command assertion

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#109` is the sprint slice for this turn
- Backlog Refinement
  - Task 45 was added and converted into issue `#109`
- Review / Demo
  - show `bin/ai` reading as helper-based command resolution while keeping the same direct commands and unknown-command behavior
- Retrospective
  - keep shell cleanup moving once user-facing contracts settle

## Verification

- `bash test/ai_cli.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - refactor top-level `ai` dispatch into helpers without changing direct-command or workflow-alias behavior
  - keep unknown-command recovery stable
  - lock the refactor with CLI tests, including explicit unknown-command coverage
- Retrospective
  - keep: use small refactors once product wording has stabilized
  - change: add one explicit recovery-path assertion whenever entrypoint dispatch is rearranged
  - stop: letting top-level command routing keep growing inline
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - cleaning shell entrypoints once outward behavior is stable
- change
  - lock refactors with a targeted recovery assertion instead of relying only on broad coverage
- stop
  - allowing top-level command dispatch to keep spreading across one case block
