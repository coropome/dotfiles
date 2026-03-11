# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #83 `docs: add beginner-first next-step guidance to ai workflows`
- Branch: `docs/83-ai-workflows-next-steps`
- Memory Artifact: `tasks/sprint-memory/issue-83.md`
- Resume Point: `ai workflows` next-step guidance landed; start the next sprint from a fresh issue-backed branch

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Make `ai workflows` act like a real beginner-path bridge instead of a flat metadata dump.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - beginner-first next-step guidance for `ai workflows`
  - concrete surfaces
  - [`bin/ai-agent`](./bin/ai-agent)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
  - acceptance slice
  - `ai workflows` ends with a compact next-step footer
  - the footer points to `ai-agent --describe --workflow <name>` before `ai start`
  - tests lock the footer wording and order
  - docs explain the new guidance without blurring `ai doctor` and `ai workflows`

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#83` is the sprint slice for this turn
- Backlog Refinement
  - Task 32 was added and converted into issue `#83`
- Review / Demo
  - show the `ai workflows` footer order: inspect one workflow, then continue with `ai start`
- Retrospective
  - keep discovery surfaces short and ordered

## Verification

- `bash test/ai_cli.sh`
- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - update [`bin/ai-agent`](./bin/ai-agent) so `ai workflows` ends with compact next-step guidance
  - keep workflow inspection ahead of workspace launch in both CLI output and docs
  - lock the footer wording and order in [`test/ai_cli.sh`](./test/ai_cli.sh)
- Retrospective
  - keep: close beginner-path gaps in the order users actually hit the surfaces
  - change: add a small next-step contract once a discovery command becomes part of the canonical path
  - stop: treating `ai workflows` like a raw metadata dump after it became a guided beginner-step
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - treating workflow discovery surfaces as part of the guided beginner path
- change
  - align the middle of the beginner path after the top-level entry surfaces are consistent
- stop
  - leaving `ai workflows` as a raw catalog when the repo now treats it as a core next step
