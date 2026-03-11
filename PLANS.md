# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #77 `docs: teach ai --help to show the beginner path before deeper commands`
- Branch: `docs/77-ai-help-beginner-path`
- Memory Artifact: `tasks/sprint-memory/issue-77.md`
- Resume Point: ai help guidance is aligned; start the next sprint from a new issue-backed branch and refresh this plan from the template

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Make `ai --help` a beginner-first discovery surface by showing the recommended next-step path before deeper commands.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

- primary deliverable
  - beginner-first `ai --help` guidance
- concrete surfaces
  - [`bin/ai`](./bin/ai)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`PLANS.md`](./PLANS.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
- acceptance slice
  - `ai --help` includes a short beginner-first path
  - starter-repo guidance puts `ai doctor` / `ai workflows` ahead of deeper commands
  - deeper commands remain visible after the first-steps section
  - tests lock the help ordering

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#77` is the sprint slice for this turn
- Backlog Refinement
  - Task 29 was added and converted into issue `#77`
- Review / Demo
  - show the new `First Steps` section in `ai --help` and its ordering
- Retrospective
  - keep `ai --help` compact while making the next step obvious

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - add a `First Steps` block to [`bin/ai`](./bin/ai) with runtime repo, starter repo, and deeper-use paths
  - align [`docs/40-cli.md`](./docs/40-cli.md) and [`README.md`](./README.md) with the new beginner-first role of `ai --help`
  - lock the line ordering in [`test/ai_cli.sh`](./test/ai_cli.sh) and the docs wording in [`test/repository_structure.sh`](./test/repository_structure.sh)
- Retrospective
  - keep: upgrade the most common entry surfaces before adding new ones
  - change: treat docs/help shape as a tested contract, not just a copy edit
  - stop: leaving `ai --help` as a flat command catalog after the rest of the repo moved to guided next steps
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
  - align top-level CLI discovery with the same beginner path used in runtime messages
- stop
  - treating `ai --help` as a flat catalog after the rest of the repo moved to guided next steps
