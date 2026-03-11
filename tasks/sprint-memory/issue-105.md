# Sprint

- issue: `#105`
- branch: `chore/105-ai-doctor-runtime-helpers`
- date: `2026-03-12`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: refactor `ai-doctor` runtime status reporting into clearer helpers without changing behavior
- decisions:
  - keep project_config, user_config, mcp_config, and project_extensions output unchanged
  - split file-backed and directory-backed runtime status reporting into dedicated helpers
  - add one extra filtered-output assertion so the refactor is not protected only by broad coverage
  - keep the sprint local to `bin/ai-doctor` and `test/ai_doctor.sh`
- constraints:
  - do not change next-step wording or doctor exit behavior
  - do not broaden the sprint into docs or new diagnostics
  - keep shell-level maintenance straightforward
- current state: `ai-doctor` now routes repeated runtime-status checks through helpers, and tests protect filtered agent output more explicitly
- next likely moves: either continue shell cleanup in another bounded slice or declare the current polish phase sufficient
- open questions: whether future cleanup should also reduce global side effects inside `report_workflow` / `report_agent`

## Lane Notes

- Product / Backlog: turned the ai-doctor cleanup opportunity into Task 43 and issue `#105`
- Delivery / Scrum: kept the sprint to one shell script plus one targeted doctor assertion
- Implementer: updating `bin/ai-doctor` and `test/ai_doctor.sh`
- Reviewer / QA: main risk is accidentally changing doctor output formatting while collapsing repeated blocks

## Retrospective Output

- keep
  - switching to narrow code-cleanliness slices once outward contract work settles
- change
  - add a targeted assertion whenever shell diagnostics are rearranged
- stop
  - letting repeated runtime-status logic stay duplicated once it becomes obviously patterned
- follow-ups
  - consider whether `report_workflow` / `report_agent` global-state coupling should be reduced in a later cleanup sprint

## System Updates

- backlog: updated
- plans: updated
- docs: not needed
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai-doctor`
  - `test/ai_doctor.sh`
- rerun commands:
  - `bash test/ai_doctor.sh`
  - `make lint`
  - `make test`
- known risks:
  - runtime status helper extraction must not alter doctor wording, ordering, or exit behavior
