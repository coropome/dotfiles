# Sprint

- issue: `#113`
- branch: `chore/113-ai-doctor-control-helpers`
- date: `2026-03-12`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: refactor `ai-doctor` control flow and state updates into clearer helpers without changing behavior
- decisions:
  - keep workflow/agent reporting and next-step wording unchanged
  - split filter validation, header/section printing, and warn/fail bookkeeping into dedicated helpers
  - add one explicit unknown-workflow assertion so the refactor is not protected only by broad doctor coverage
  - keep the sprint local to `bin/ai-doctor` and `test/ai_doctor.sh`
- constraints:
  - do not change doctor output ordering
  - do not broaden the sprint into new diagnostics or docs
  - keep helper extraction understandable for shell maintenance
- current state: ai-doctor now reads more like staged reporting over helpers, and doctor tests protect unknown-workflow recovery more explicitly
- next likely moves: either continue shell cleanup in one more bounded slice or shift fully into expansion work
- open questions: whether global per-agent metadata in `ai-doctor` should eventually move toward more local return values

## Lane Notes

- Product / Backlog: turned the ai-doctor control-flow cleanup opportunity into Task 47 and issue `#113`
- Delivery / Scrum: kept the sprint to one shell report surface plus one targeted doctor assertion
- Implementer: updating `bin/ai-doctor` and `test/ai_doctor.sh`
- Reviewer / QA: main risk is accidentally changing section ordering or next-step behavior while extracting helpers

## Retrospective Output

- keep
  - bundling related cleanup work into one issue instead of many tiny PRs
- change
  - add a targeted recovery assertion whenever reporting control flow is rearranged
- stop
  - letting ai-doctor mix validation, printing, and state mutation inline once the contract has stabilized
- follow-ups
  - consider whether one more pass should reduce per-agent global metadata coupling

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
  - helper extraction must not alter report ordering, next-step wording, or exit behavior
