# Sprint

- issue: `#107`
- branch: `chore/107-ai-init-readme-helpers`
- date: `2026-03-12`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: refactor `ai-init` starter README generation into clearer helpers without changing generated output
- decisions:
  - keep the generated starter README wording unchanged across current flag variants
  - split repeated README sections into dedicated helpers
  - add one explicit duplication assertion for `## If Something Fails`
  - keep the sprint local to `bin/ai-init` and `test/ai_init.sh`
- constraints:
  - do not change ai-init flags or output order
  - do not broaden the sprint into new docs or starter files
  - keep the helper structure simple enough for shell maintenance
- current state: `ai-init` now assembles the starter README from section helpers, and tests protect against accidentally duplicating the failure-model section
- next likely moves: either continue shell cleanup in another bounded slice or shift attention to new capabilities
- open questions: whether future cleanup should also factor the final `next:` CLI output lines into reusable helpers

## Lane Notes

- Product / Backlog: turned the ai-init cleanup opportunity into Task 44 and issue `#107`
- Delivery / Scrum: kept the sprint to one shell script plus one targeted test helper
- Implementer: updating `bin/ai-init` and `test/ai_init.sh`
- Reviewer / QA: main risk is accidentally changing generated README wording while extracting shared sections

## Retrospective Output

- keep
  - switching to narrow code-cleanliness slices once outward contract work settles
- change
  - add a duplication guard whenever a long generated document is restructured
- stop
  - letting generated README variants repeat large section blocks inline
- follow-ups
  - consider whether ai-init CLI summary output should also be assembled from small helpers later

## System Updates

- backlog: updated
- plans: updated
- docs: not needed
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai-init`
  - `test/ai_init.sh`
- rerun commands:
  - `bash test/ai_init.sh`
  - `make lint`
  - `make test`
- known risks:
  - section helper extraction must not change generated README wording or section order
