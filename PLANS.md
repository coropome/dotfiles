# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #89 `docs: align newcomer docs with ai-start backend options`
- Branch: `docs/89-ai-start-backend-docs`
- Memory Artifact: `tasks/sprint-memory/issue-89.md`
- Resume Point: newcomer docs now reflect tmux default plus stdio alternative; next sprint can move to generated starter or richer backend surfaces

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Align newcomer-facing docs with the current `ai start` backend contract so terminal choice stays flexible in practice as well as in code.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - newcomer/docs alignment for `ai start` backends
  - concrete surfaces
  - [`README.md`](./README.md)
  - [`docs/00-quickstart.md`](./docs/00-quickstart.md)
  - [`docs/05-demo-walkthrough.md`](./docs/05-demo-walkthrough.md)
  - [`docs/99-troubleshooting.md`](./docs/99-troubleshooting.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/demo_assets.sh`](./test/demo_assets.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
  - acceptance slice
  - high-traffic newcomer docs mention `tmux` as the current default and `stdio` as an alternative
  - troubleshooting points to `stdio` as a valid escape hatch when only the tmux default path is blocked
  - demo walkthrough stays aligned with the beginner path while exposing the stdio option
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
  - issue `#89` is the sprint slice for this turn
- Backlog Refinement
  - Task 35 was added and converted into issue `#89`
- Review / Demo
  - show tmux as default backend and stdio as the lighter newcomer-facing alternative
- Retrospective
  - keep docs aligned immediately after behavior changes

## Verification

- `bash test/demo_assets.sh`
- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - align README, quickstart, demo walkthrough, and troubleshooting with `tmux` default plus `stdio` alternative
  - keep the newcomer path order unchanged while exposing the non-tmux escape hatch
  - lock the wording with structure and demo guards
- Retrospective
  - keep: update the highest-traffic docs right after changing a core entrypoint contract
  - change: treat troubleshooting as part of the beginner-path contract, not as an afterthought
  - stop: leaving newcomer docs on an older backend story after the code moves ahead
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - keeping high-traffic docs aligned with code-level backend changes
- change
  - move the docs follow-through into the very next sprint when an entrypoint contract changes
- stop
  - assuming CLI docs alone are enough once README and troubleshooting still say less
