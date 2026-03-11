# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #99 `docs: teach ai-start --help the backend choice contract`
- Branch: `docs/99-ai-start-help-backend-contract`
- Memory Artifact: `tasks/sprint-memory/issue-99.md`
- Resume Point: ai-start --help now explains tmux default, stdio alternative, and the env override; next sprint can move to the remaining demo/backend drift if any still matters

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Align `ai-start --help` with the current backend contract so the command-specific help surface tells the same story as launch, recovery, and docs.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - backend-aware `ai-start --help`
  - concrete surfaces
  - [`bin/ai-start`](./bin/ai-start)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
  - acceptance slice
  - `ai-start --help` mentions the tmux default
  - `ai-start --help` mentions the stdio alternative and env override
  - docs explain the backend-aware help output
  - tests guard the new wording and ordering

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#99` is the sprint slice for this turn
- Backlog Refinement
  - Task 40 was added and converted into issue `#99`
- Review / Demo
  - show `ai-start --help` with tmux default, stdio alternative, and the env override
- Retrospective
  - keep command-specific help aligned right after backend contract changes

## Verification

- `bash test/ai_cli.sh`
- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - align `ai-start --help` with `tmux` default plus `stdio` alternative
  - keep the env override visible without turning help into a long tutorial
  - lock the wording with CLI and structure guards
- Retrospective
  - keep: follow backend-contract changes through command-specific help as soon as a command gains multiple viable paths
  - change: treat `ai-start --help` as a durable contract once it teaches backend selection
  - stop: relying on broad docs when the command's own help still says less
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - keeping command-specific help aligned with backend changes
- change
  - update `ai-start --help` immediately after new backend options are introduced
- stop
  - assuming broader docs are enough when command help still hides backend choice
