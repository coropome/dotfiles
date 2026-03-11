# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #75 `docs: align ai start workspace-ready guidance with the beginner path`
- Branch: `docs/75-ai-start-guidance`
- Memory Artifact: `tasks/sprint-memory/issue-75.md`
- Resume Point: ai-start guidance is aligned; start the next sprint from a new issue-backed branch and refresh this plan from the template

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Align `ai start` workspace-ready guidance with the repo's beginner path so the first post-launch next steps are `ai doctor` and `ai workflows`.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

- primary deliverable
  - beginner-first `ai start` workspace-ready guidance
- concrete surfaces
  - [`bin/ai-start`](./bin/ai-start)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`PLANS.md`](./PLANS.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`test/ai_cli.sh`](./test/ai_cli.sh)
- acceptance slice
  - `ai start` prints `ai doctor` and `ai workflows` in its ready guidance
  - beginner guidance appears before deeper commands
  - deeper commands remain visible after the beginner guidance
  - tests lock the updated guidance ordering

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#75` is the sprint slice for this turn
- Backlog Refinement
  - Task 28 was added and converted into issue `#75`
- Review / Demo
  - show the post-start next-step guidance and its ordering
- Retrospective
  - keep the workspace-ready message short and terminal-friendly

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - update [`bin/ai-start`](./bin/ai-start) so workspace-ready guidance starts with `ai doctor | ai workflows`
  - keep deeper commands visible after the beginner guidance
  - lock the guidance ordering and success path in [`test/ai_cli.sh`](./test/ai_cli.sh)
  - add a docs drift guard in [`test/repository_structure.sh`](./test/repository_structure.sh)
- Retrospective
  - keep: make post-launch guidance match the same beginner path used in docs
  - change: assert command success as part of UX guidance tests instead of only inspecting output text
  - stop: leaving `ai start` on an older command list after the rest of the repo moved to `ai doctor -> ai workflows -> ai start`
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
  - align workspace launch messaging with the same beginner path used everywhere else
- stop
  - leaving `ai start` on an older command list that does not match current onboarding guidance
