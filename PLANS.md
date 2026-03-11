# AI Dev OS Plan

- Date: 2026-03-11
- Active issue: #65 `docs: default each user turn to one sprint with agent-run Scrum`
- Branch: `docs/65-turn-scoped-sprint-rule`
- Memory Artifact: `not needed in this turn-scoped sprint; fallback location is tasks/sprint-memory/`

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Make the collaboration cadence explicit: one user/assistant round-trip defaults to one sprint, and agents are responsible for running planning, execution, review/demo, and retrospective inside that turn unless the issue intentionally spans multiple turns.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

- primary deliverable
  - a durable turn-scoped sprint rule for this collaboration style
- concrete surfaces
  - [`docs/92-development-workflow.md`](./docs/92-development-workflow.md)
  - [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md)
  - [`AGENTS.md`](./AGENTS.md)
  - [`.github/copilot-instructions.md`](./.github/copilot-instructions.md)
  - [`docs/adr/0005-turn-scoped-sprint-cadence.md`](./docs/adr/0005-turn-scoped-sprint-cadence.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
- acceptance slice
  - turn-scoped sprint default is explicit
  - exceptions for intentional multi-turn work are explicit
  - agent-facing instructions reflect the rule

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Reviewer / QA: Codex

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#65` is the sprint slice for this turn
- Backlog Refinement
  - Task 24 was added and converted into issue `#65`
- Review / Demo
  - leave proof in docs and structure tests
- Retrospective
  - keep the turn-scoped rule lightweight and exception-driven

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Retrospective

- keep
  - treating workflow rules as repo artifacts, not just chat habits
- change
  - make the turn boundary explicit earlier so cadence expectations are visible
- stop
  - relying on implicit conversation rhythm as the only sprint definition
