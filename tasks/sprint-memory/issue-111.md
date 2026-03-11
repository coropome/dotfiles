# Sprint

- issue: `#111`
- branch: `chore/111-ai-agent-resolution-helpers`
- date: `2026-03-12`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: refactor `ai-agent` resolution and describe flows into clearer helpers without changing behavior
- decisions:
  - keep config-path output, workflow candidate resolution, describe output, and recovery stderr unchanged
  - split config-path printing, unknown workflow/agent reporting, candidate deduplication, and describe rendering into dedicated helpers
  - add one explicit unknown-workflow assertion so the refactor is not protected only by broad CLI coverage
  - keep the sprint local to `bin/ai-agent` and `test/ai_cli.sh`
- constraints:
  - do not change launch handoff semantics
  - do not broaden the sprint into new workflow features
  - keep helper extraction understandable for shell maintenance
- current state: `ai-agent` now reads more like staged resolution over helpers, and CLI tests protect unknown-workflow recovery more explicitly
- next likely moves: either continue shell cleanup in another bounded slice or move to feature expansion
- open questions: whether `ai-doctor` global-state reduction is the next highest-value cleanup once `ai-agent` is no longer the heaviest script

## Lane Notes

- Product / Backlog: turned the ai-agent cleanup opportunity into Task 46 and issue `#111`
- Delivery / Scrum: kept the sprint to one heavy shell surface plus one targeted CLI assertion
- Implementer: updating `bin/ai-agent` and `test/ai_cli.sh`
- Reviewer / QA: main risk is accidentally changing describe output or unknown-workflow recovery while splitting helpers

## Retrospective Output

- keep
  - switching to bounded refactor bundles instead of one tiny issue at a time
- change
  - add a targeted recovery assertion whenever shell resolution logic is rearranged
- stop
  - letting the heaviest remaining shell surface stay monolithic once its contracts are stable
- follow-ups
  - consider `ai-doctor` global-state reduction as the next cleanup target

## System Updates

- backlog: updated
- plans: updated
- docs: not needed
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai-agent`
  - `test/ai_cli.sh`
- rerun commands:
  - `bash test/ai_cli.sh`
  - `make lint`
  - `make test`
- known risks:
  - helper extraction must not alter describe output ordering or recovery stderr guidance
