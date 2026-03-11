# AI Dev OS Plan

- Date: 2026-03-11
- Sprint Status: `closed`
- Sprint Scope: `turn-scoped`
- Active issue: #101 `docs: make demo sample-project README backend-aware`
- Branch: `docs/101-demo-readme-backend-guidance`
- Memory Artifact: `tasks/sprint-memory/issue-101.md`
- Resume Point: demo sample-project README now explains tmux default plus the stdio alternative; next sprint can decide whether the remaining foundation work is finished or if one more polish slice is worthwhile

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Align the demo sample-project README with the current backend contract so the staged fixture entrypoint tells the same story as the starter README, walkthrough, and CLI surfaces.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- default to 1 user turn = 1 sprint
- only span multiple turns when the issue explicitly justifies it
- end the turn with review/demo evidence and a retrospective outcome

## Sprint Slice

  - primary deliverable
  - backend-aware demo sample-project README
  - concrete surfaces
  - [`demo/sample-project/README.md`](./demo/sample-project/README.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`PLANS.md`](./PLANS.md)
  - [`test/demo_assets.sh`](./test/demo_assets.sh)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
  - acceptance slice
  - the demo README says `tmux` is the current default backend
  - the demo README mentions `ai start --repo demo/sample-project --backend stdio`
  - demo and structure tests guard the wording and order

## Squad

- Product / Backlog: Codex
- Delivery / Scrum: Codex
- Implementer: Codex
- Reviewer / QA: Codex
- Docs / Onboarding specialist: Avicenna
- Reviewer / QA specialist: Mendel

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#101` is the sprint slice for this turn
- Backlog Refinement
  - Task 41 was added and converted into issue `#101`
- Review / Demo
  - show Stage 3 of `demo/sample-project/README.md` with tmux default plus the stdio alternative
- Retrospective
  - keep the staged demo entrypoint aligned right after backend contract changes

## Verification

- `bash test/demo_assets.sh`
- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Closeout

- Review / Demo
  - align the demo sample-project Stage 3 wording with `tmux` default plus `stdio` alternative
  - keep the staged local-first flow intact while removing tmux-only wording
  - lock the wording with demo and structure guards
- Retrospective
  - keep: follow backend-contract changes through every newcomer-facing surface, including demo fixtures
  - change: treat the demo README as a durable contract once it becomes the sample staged adoption entrypoint
  - stop: leaving the demo surface on an older tmux-only story after the product has moved on
- System Updates
  - backlog: updated
  - plans: updated
  - docs: updated
  - tests: updated
  - instructions: not needed
  - ADR: not needed

## Retrospective

- keep
  - keeping the staged demo entrypoint aligned with backend changes
- change
  - update demo fixture wording immediately after backend options change
- stop
  - assuming walkthroughs are enough when the demo README still hides backend choice
