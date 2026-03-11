# Sprint

- issue: `#109`
- branch: `chore/109-ai-dispatch-helpers`
- date: `2026-03-12`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: refactor top-level `ai` command dispatch into clearer helpers without changing behavior
- decisions:
  - keep direct command routing, workflow alias routing, and unknown-command recovery unchanged
  - split direct dispatch, workflow alias dispatch, and unknown-command recovery into dedicated helpers
  - add one explicit unknown-command assertion so the refactor is not protected only by broad CLI coverage
  - keep the sprint local to `bin/ai` and `test/ai_cli.sh`
- constraints:
  - do not change help wording or workflow alias behavior
  - do not broaden the sprint into ai-agent or ai-doctor
  - keep the top-level flow simple enough for shell maintenance
- current state: `bin/ai` now reads as helper-based command resolution, and CLI tests protect the unknown-command stderr contract more explicitly
- next likely moves: either keep refactoring shell entrypoints in small slices or shift attention to new capabilities
- open questions: whether `ai-agent` should be the next target because it now carries the heaviest remaining output/dispatch logic

## Lane Notes

- Product / Backlog: turned the top-level ai cleanup opportunity into Task 45 and issue `#109`
- Delivery / Scrum: kept the sprint to one shell entrypoint plus one targeted CLI assertion
- Implementer: updating `bin/ai` and `test/ai_cli.sh`
- Reviewer / QA: main risk is accidentally changing unknown-command behavior or workflow alias resolution while splitting helpers

## Retrospective Output

- keep
  - switching to narrow code-cleanliness slices once outward contract work settles
- change
  - add a targeted recovery-path assertion whenever entrypoint dispatch is rearranged
- stop
  - letting top-level command routing keep growing inline
- follow-ups
  - consider whether `ai-agent` should be the next shell cleanup target

## System Updates

- backlog: updated
- plans: updated
- docs: not needed
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai`
  - `test/ai_cli.sh`
- rerun commands:
  - `bash test/ai_cli.sh`
  - `make lint`
  - `make test`
- known risks:
  - helper extraction must not alter unknown-command stderr guidance or workflow alias execution
