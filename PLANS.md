# AI Dev OS Plan

- Date: 2026-03-11
- Active issue: #53 `docs: make retrospectives update the system and preserve agent memory`
- Branch: `docs/53-retro-memory-loop`
- Memory Artifact: [`tasks/sprint-memory/issue-53.md`](./tasks/sprint-memory/issue-53.md)

## North Star

- make AI Dev OS feel like an OS-level workbench for AI workflows: obvious for beginners, faster and deeper for experienced users
- make it durable enough to still be the right daily tool a year later, not a one-shot workflow wrapper tied to a short-lived trend
- make the first successful repo-local path obvious in any repo: `ai init -> ai doctor -> ai workflows -> ai start`
- keep local onboarding as the default story; CI, hosted eval, and runtime pinning stay as later lanes
- prefer project-local config and vendor-native capability over shell-wrapper reimplementation
- keep every newcomer-facing surface aligned on the same failure model and next-step guidance

## Current Goal

Make retrospectives improve the operating system instead of ending as dead-end notes, and preserve compressed sprint memory so multi-agent work can survive context loss and handoff.

## Working Agreement

Active multi-step work follows [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md).

- start from `tasks/backlog.md`, then commit to an issue-backed sprint slice
- keep `PLANS.md` restartable throughout the sprint
- keep compressed handoff context in [`tasks/sprint-memory/`](./tasks/sprint-memory/)
- end the sprint with review/demo evidence, retrospective output, and explicit system updates

## Sprint Slice

- primary deliverable
  - a durable retrospective feedback loop and sprint-memory contract
- concrete surfaces
  - [`docs/92-development-workflow.md`](./docs/92-development-workflow.md)
  - [`docs/93-scrum-delivery.md`](./docs/93-scrum-delivery.md)
  - [`AGENTS.md`](./AGENTS.md)
  - [`.github/copilot-instructions.md`](./.github/copilot-instructions.md)
  - [`tasks/sprint-memory/README.md`](./tasks/sprint-memory/README.md)
  - [`tasks/sprint-memory/issue-53.md`](./tasks/sprint-memory/issue-53.md)
  - [`tasks/backlog.md`](./tasks/backlog.md)
  - [`test/repository_structure.sh`](./test/repository_structure.sh)
- acceptance slice
  - retrospectives map to backlog / plans / docs / tests / instructions / ADR or explicit no-op
  - the repo defines a standard compressed sprint memory location and format
  - active planning surfaces point to sprint memory artifacts

## Squad

- Product / Backlog: Codex
  - owns issue shape, acceptance criteria, and backlog refinement
- Delivery / Scrum: Codex
  - owns sprint commitment, plan hygiene, and ceremony completion
- Explorer / Design: Gibbs
  - scans memory artifact shape and handoff clarity
- Explorer / Guardrails: Hypatia
  - scans regression guards and wording drift

## Current Sprint Ceremonies

- Sprint Planning
  - issue `#53`, branch `docs/53-retro-memory-loop`, and memory artifact path are fixed
- Backlog Refinement
  - Task 21 was added and converted into issue `#53`
- Review / Demo
  - leave proof in docs, tests, and the sprint-memory artifact
- Retrospective
  - capture keep / change / stop and which system surfaces were updated

## Verification

- `bash test/repository_structure.sh`
- `make lint`
- `make test`

## Retrospective

- keep
  - using the current sprint itself as the first real memory-artifact trial
- change
  - standardize one artifact path before more branches invent alternatives
- stop
  - leaving handoff context only in ephemeral agent state
