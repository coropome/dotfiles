# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #81 `docs: align unknown-command recovery in ai with the beginner path`
- Branch: `docs/81-ai-unknown-command-guidance`
- Memory Artifact: `tasks/sprint-memory/issue-81.md`
- Resume Point: unknown-command recovery is aligned; start the next sprint from a new issue-backed branch and refresh this plan from the template

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Align the generic unknown-command recovery path in `ai` with the same beginner-first order used by help, start, and doctor.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

- primary deliverable
  - beginner-first unknown-command recovery guidance
- concrete surfaces
  - [`bin/ai`](./bin/ai)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
- acceptance slice
  - unknown-command output points to `ai doctor` before `ai workflows`
  - workflow-alias discovery remains visible in the fallback output
  - tests lock the fallback ordering
  - any touched docs keep the same recovery order

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#81` is the sprint slice for this turn
- Backlog Refinement
  - Task 31 was added and converted into issue `#81`
- Review / Demo
  - show the unknown-command recovery order and keep workflow discovery visible
- Retrospective
  - keep the unknown-command path short and terminal-friendly

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - update [`bin/ai`](./bin/ai) so unknown-command fallback points to `ai doctor` before `ai workflows`
  - keep workflow-alias discovery visible after the doctor-first remediation
  - align [`docs/40-cli.md`](./docs/40-cli.md) and lock the fallback order in [`test/ai_cli.sh`](./test/ai_cli.sh)
- Retrospective
  - keep: close the broadest fallback paths after the stronger happy-path surfaces are aligned
  - change: add a narrow docs guard when a recovery phrase becomes part of the canonical CLI story
  - stop: letting generic fallback surfaces lag behind the guided beginner path
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
  - align generic fallback paths with the same beginner path used in the stronger entry surfaces
- stop
  - leaving one broad fallback path on an older, thinner recovery story
