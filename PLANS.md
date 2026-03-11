# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #111 `chore: refactor ai-agent resolution helpers`
- Branch: `chore/111-ai-agent-resolution-helpers`
- Memory Artifact: `tasks/sprint-memory/issue-111.md`
- Resume Point: ai-agent now routes config-path output, candidate resolution, and describe/recovery paths through helpers; next sprint can keep tightening shell internals or move into expansion work

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Refactor `ai-agent` resolution and describe flows so the code stays easy to read and extend without changing the current workflow routing and recovery contracts.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - cleaner `ai-agent` resolution and describe flow
  - concrete surfaces
  - [`bin/ai-agent`](./bin/ai-agent)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
  - acceptance slice
  - `ai-agent` keeps current list, describe, workflow resolution, and launch behavior unchanged
  - config-path output, candidate resolution, and describe/recovery logic move into clearer helpers
  - tests lock the refactor with an explicit unknown-workflow recovery assertion

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#111` is the sprint slice for this turn
- Backlog Refinement
  - Task 46 was added and converted into issue `#111`
- Review / Demo
  - show `bin/ai-agent` reading as helper-based resolution while keeping the same describe and recovery behavior
- Retrospective
  - keep shell cleanup moving once user-facing contracts settle

## Verification

- `bash test/ai_cli.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - refactor `ai-agent` resolution and describe flows into helpers without changing routing behavior
  - keep unknown-workflow and unknown-agent recovery stable
  - lock the refactor with CLI tests, including explicit unknown-workflow coverage
- Retrospective
  - keep: use small refactors once product wording has stabilized
  - change: add one explicit recovery-path assertion whenever resolution logic is rearranged
  - stop: letting `ai-agent` keep accumulating one long staged control path
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - cleaning heavy shell resolution surfaces once outward behavior is stable
- change
  - lock refactors with a targeted recovery assertion instead of relying only on broad coverage
- stop
  - allowing ai-agent resolution, describe, and recovery logic to keep spreading across one control path
