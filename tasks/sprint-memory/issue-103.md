# Sprint

- issue: `#103`
- branch: `chore/103-ai-start-backend-helpers`
- date: `2026-03-12`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: refactor `ai-start` backend handling into clearer helpers without changing behavior
- decisions:
  - keep the tmux/stdio contract byte-for-byte compatible where practical
  - split backend validation, stop, launch, and attach behavior into dedicated helpers
  - add one explicit unknown-backend assertion so the refactor is not protected only by happy-path tests
  - keep the refactor local to `bin/ai-start` and `test/ai_cli.sh`
- constraints:
  - do not change the current backend semantics
  - do not broaden the sprint into docs or new backends
  - keep the script readable for shell-level maintenance
- current state: `ai-start` reads as orchestration over helpers instead of repeated backend case blocks, and CLI tests cover the unknown-backend edge path
- next likely moves: decide whether to keep polishing shell internals or move focus to new functionality
- open questions: whether a later shell cleanup should extract shared backend phrasing into a reusable helper layer across commands

## Lane Notes

- Product / Backlog: turned the code-cleanliness ask into Task 42 and issue `#103`
- Delivery / Scrum: kept the sprint to one shell script plus one targeted test addition
- Implementer: updating `bin/ai-start` and `test/ai_cli.sh`
- Reviewer / QA: main risk is accidentally changing stdout/stderr or attach behavior while simplifying control flow

## Retrospective Output

- keep
  - switching to small refactors once outward contract work settles
- change
  - add a targeted edge-case assertion whenever shell control flow is rearranged
- stop
  - letting backend orchestration keep spreading across repeated case blocks
- follow-ups
  - consider whether future shell cleanup should share backend phrasing more centrally across commands

## System Updates

- backlog: updated
- plans: updated
- docs: not needed
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai-start`
  - `test/ai_cli.sh`
- rerun commands:
  - `bash test/ai_cli.sh`
  - `make lint`
  - `make test`
- known risks:
  - refactor must not alter tmux attach behavior or the current stderr contract
