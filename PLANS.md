# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #97 `feat: make ai-start tmux failure mention the stdio path`
- Branch: `feat/97-ai-start-stdio-recovery`
- Memory Artifact: `tasks/sprint-memory/issue-97.md`
- Resume Point: ai-start tmux-missing failures now mention the stdio path; next sprint can decide whether any remaining backend-contract surfaces still lag behind

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Align the direct `ai start` tmux-failure path with the current backend contract so launch recovery tells the same story as help, docs, and starter guidance.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - backend-aware `ai start` tmux-failure recovery
  - concrete surfaces
  - [`bin/ai-start`](./bin/ai-start)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
  - acceptance slice
  - `ai start` tmux-missing failures mention `ai start --backend stdio`
  - tmux remediation stays visible alongside the stdio alternative
  - docs explain the backend-aware failure path
  - tests guard the new wording

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#97` is the sprint slice for this turn
- Backlog Refinement
  - Task 39 was added and converted into issue `#97`
- Review / Demo
  - show the `ai start` tmux-missing failure with both tmux remediation and the stdio alternative
- Retrospective
  - keep recovery surfaces aligned after backend contract changes, not just docs and help

## Verification

- `bash test/ai_cli.sh`
- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - align `ai start` tmux-missing failures with `tmux` default plus `stdio` alternative
  - keep tmux remediation visible while adding the stdio fallback
  - lock the wording with CLI and structure guards
- Retrospective
  - keep: follow backend-contract changes through recovery surfaces as soon as they become user-facing guidance
  - change: treat `ai start` failure stderr as part of the durable backend contract once it teaches a fallback
  - stop: leaving launch failures on an older tmux-only recovery story
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - keeping direct launch recovery aligned with backend changes
- change
  - update `ai start` failure guidance immediately after new backend options are introduced
- stop
  - assuming troubleshooting docs are enough when the direct launch failure still says less
