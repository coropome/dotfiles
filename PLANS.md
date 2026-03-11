# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #87 `feat: add a workspace backend adapter to ai start`
- Branch: `feat/87-ai-start-backend-adapter`
- Memory Artifact: `tasks/sprint-memory/issue-87.md`
- Resume Point: ai-start backend adapter landed; next sprint can explore richer backends from a fresh issue-backed branch

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Implement the first workspace backend adapter so `ai start` keeps tmux as default without fixing terminal choice forever.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - `ai start` workspace backend adapter
  - concrete surfaces
  - [`bin/ai-start`](./bin/ai-start)
  - [`docs/31-support-matrix.md`](./docs/31-support-matrix.md)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
  - acceptance slice
  - `ai start` supports backend selection
  - default behavior remains tmux-backed
  - `stdio` backend works without tmux
  - docs explain backend selection and current default
  - tests cover backend selection and the non-tmux path

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#87` is the sprint slice for this turn
- Backlog Refinement
  - Task 34 was converted into issue `#87`
- Review / Demo
  - show tmux as default backend and stdio as a non-tmux alternative
- Retrospective
  - keep backend abstraction narrower than terminal strategy

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - update [`bin/ai-start`](./bin/ai-start) to support backend selection with tmux as default and stdio as the first alternative
  - align [`docs/40-cli.md`](./docs/40-cli.md) and [`docs/31-support-matrix.md`](./docs/31-support-matrix.md) with the new backend contract
  - lock the non-tmux path in [`test/ai_cli.sh`](./test/ai_cli.sh)
- Retrospective
  - keep: prove the abstraction with one small alternative backend before considering terminal-native integrations
  - change: encode backend defaults and alternatives in output/docs/tests together
  - stop: treating tmux-only implementation as enough once the boundary is already explicit
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - keeping implementation aligned with the already-decided architecture boundary
- change
  - prove backend flexibility with a small non-tmux mode first
- stop
  - leaving terminal choice fixed in practice after deciding it should stay flexible
