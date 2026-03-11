# AI Dev OS Plan

- Date: `YYYY-MM-DD`
- Sprint Status: `active`
- Sprint Scope: `turn-scoped`
- Active issue: `#<id> short title`
- Branch: `<type>/<id>-short-name`
- Memory Artifact: `tasks/sprint-memory/issue-<id>.md` or `not needed in this sprint`
- Resume Point: `next concrete step`

Use `Sprint Status: multi-turn` and `Sprint Scope: multi-turn` when the issue intentionally spans more than one user turn.
Use `Sprint Status: closed` after review/demo and retrospective are complete for the sprint.

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

- `what this sprint is trying to achieve`

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](../../docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

- primary deliverable
  - `what lands in this sprint`
- concrete surfaces
  - [`PLANS.md`](../../PLANS.md)
- acceptance slice
  - `verifiable outcome`

## Squad

- Product / Backlog:
- Delivery / Scrum:
- Implementer:
- Reviewer / QA:

## Current Sprint Ceremonies

- Sprint Planning
  - `issue and branch for this sprint`
- Backlog Refinement
  - `next candidate or backlog update`
- Review / Demo
  - `what will prove the sprint goal`
- Retrospective
  - `what to keep lightweight or change next`

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - `what changed`
- Retrospective
  - keep:
  - change:
  - stop:
- System Updates
  - backlog:
  - plans:
  - docs:
  - tests:
  - instructions:
  - ADR:
