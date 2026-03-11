# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #79 `docs: add beginner-first next-step guidance to ai doctor`
- Branch: `docs/79-ai-doctor-next-steps`
- Memory Artifact: `tasks/sprint-memory/issue-79.md`
- Resume Point: ai-doctor next-step guidance is aligned; start the next sprint from a new issue-backed branch and refresh this plan from the template

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Make `ai doctor` a better recovery surface by ending with beginner-first next-step guidance for healthy, warn, and fail outcomes.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

- primary deliverable
  - beginner-first `ai doctor` next-step guidance
- concrete surfaces
  - [`bin/ai-doctor`](./bin/ai-doctor)
  - [`docs/40-cli.md`](./docs/40-cli.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/ai_doctor.sh`](./test/ai_doctor.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
- acceptance slice
  - `ai doctor` prints a compact next-step block at the end
  - healthy output points to `ai workflows` before `ai start`
  - warn output keeps beginner-first ordering and can point to deeper inspection after `ai workflows`
  - fail output tells users to fix gaps and rerun `ai doctor` before `ai start`

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#79` is the sprint slice for this turn
- Backlog Refinement
  - Task 30 was added and converted into issue `#79`
- Review / Demo
  - show the new `ai doctor` next-step block for healthy, warn, and fail cases
- Retrospective
  - keep `ai doctor` terminal-short and explicit about what to do next

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - add an outcome-based `Next Steps` footer to [`bin/ai-doctor`](./bin/ai-doctor)
  - keep healthy output on `ai workflows -> ai start`, warn output on `ai workflows -> optional ai-agent --describe --workflow <name> -> ai start`, and fail output on `fix -> rerun ai doctor -> ai workflows`
  - align [`docs/40-cli.md`](./docs/40-cli.md) and lock the footer ordering in [`test/ai_doctor.sh`](./test/ai_doctor.sh)
- Retrospective
  - keep: extend beginner-first guidance to recovery surfaces after discovery and startup surfaces are aligned
  - change: treat the exact last lines of diagnostic output as part of the contract when the task is specifically about next steps
  - stop: ending the canonical recovery command with no clear next action
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
  - align the recovery surface with the same beginner path used in discovery and startup messages
- stop
  - leaving `ai doctor` as a raw diagnostic dump after the rest of the repo moved to guided next steps
