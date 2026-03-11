# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #95 `docs: teach ai --help the ai-start backend contract`
- Branch: `docs/95-ai-help-backend-guidance`
- Memory Artifact: `tasks/sprint-memory/issue-95.md`
- Resume Point: ai --help now shows the tmux-default/stdio-alternative backend note; next sprint can decide whether to tighten troubleshooting or backend contract docs further

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Align `ai --help` with the current `ai start` backend contract so the highest-traffic CLI discovery surface tells the same story as launch and recovery surfaces.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - backend-aware `ai --help` first steps
  - concrete surfaces
  - [`bin/ai`](./bin/ai)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
  - acceptance slice
  - `ai --help` shows a backend note for tmux default plus the stdio alternative
  - the backend note stays between the runtime and starter first-step lines
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
  - issue `#95` is the sprint slice for this turn
- Backlog Refinement
  - Task 38 was added and converted into issue `#95`
- Review / Demo
  - show `ai --help` with the backend note between the runtime and starter first-step paths
- Retrospective
  - keep high-traffic discovery surfaces aligned right after backend contract changes

## Verification

- `bash test/ai_cli.sh`
- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - align `ai --help` first steps with `tmux` default plus `stdio` alternative
  - keep the backend note between the runtime and starter paths
  - lock the wording with CLI and structure guards
- Retrospective
  - keep: follow backend-contract changes through the highest-traffic surfaces first
  - change: treat `ai --help` first-step lines as part of the durable backend contract
  - stop: leaving help output on an older single-path story after other surfaces changed
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - keeping high-traffic CLI discovery aligned with backend changes
- change
  - update `ai --help` immediately after launch and recovery surfaces change
- stop
  - assuming deeper docs can carry backend nuance when `ai --help` still hides it
