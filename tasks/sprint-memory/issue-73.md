# Sprint

- issue: `#73`
- branch: `feat/73-ai-task-pending-summary`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex + Mendel
  - Docs / Onboarding specialist: Avicenna

## Compressed Memory

- goal: make `ai task` a better backlog-refinement entrypoint by summarizing pending work before printing the full backlog
- decisions:
  - keep the existing `ai task` command instead of adding a new backlog subcommand
  - prepend a short pending summary and then print the unchanged backlog body
  - make the help/docs text explicitly about backlog refinement and next-sprint selection
  - test pending and no-pending cases against fixed fixtures so the suite does not depend on the live repo backlog state
- constraints:
  - stay within one turn-scoped sprint
  - avoid turning `ai task` into an interactive task manager
  - keep the backlog file as the source of truth
- current state: `ai task` shows pending summary + full backlog, docs/help are updated, and tests cover ordering plus no-pending fallback
- next likely moves: consider whether backlog refinement needs richer filters later, but only if the text summary stops being enough
- open questions: whether future backlog scale justifies optional filters without violating the repo's preference for simple text surfaces

## Lane Notes

- Product / Backlog: converted the next operator-experience gap into Task 27 and issue `#73`
- Delivery / Scrum: kept the sprint limited to one existing command, docs/help wording, and tests
- Implementer: updated `bin/ai-task`, `bin/ai`, `docs/40-cli.md`, and `test/ai_cli.sh`
- Reviewer / QA: review feedback tightened the tests around summary-before-body ordering and exclusion of closed tasks from the summary

## Retrospective Output

- keep
  - improving existing operator entrypoints before adding new command surfaces
- change
  - test against fixture backlogs when repo state is expected to change during the sprint
- stop
  - treating backlog refinement as a raw file-viewing task only
- follow-ups
  - revisit optional filters only if the plain-text summary stops being enough at current backlog scale

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai-task`
  - `docs/40-cli.md`
  - `test/ai_cli.sh`
- rerun commands:
  - `bash test/ai_cli.sh`
  - `make lint`
  - `make test`
- known risks:
  - if backlog formatting changes substantially, the summary parser and fixture tests will need to move together
