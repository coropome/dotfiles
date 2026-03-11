# Sprint

- issue: `#81`
- branch: `docs/81-ai-unknown-command-guidance`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: align the broad unknown-command fallback in `ai` with the same beginner-first recovery order used by help, start, and doctor
- decisions:
  - keep the fallback short and stderr-only
  - point users to `ai doctor` first, then `ai workflows`
  - keep workflow-alias discovery visible after the doctor-first remediation
  - add a narrow docs line and guard so the fallback story does not drift
- constraints:
  - stay within one turn-scoped sprint
  - avoid redesigning `ai --help` or adding interactive command suggestions
  - do not hide existing workflow-alias hints
- current state: unknown-command fallback now suggests `ai doctor` before `ai workflows`, docs reflect that, and tests lock the ordering
- next likely moves: inspect whether top-level docs still slightly over-compress the `ai --help` / `ai doctor` / `ai start` relationship
- open questions: whether future CLI growth needs an explicit “common recovery paths” doc section, or whether the current lightweight wording is enough

## Lane Notes

- Product / Backlog: converted the remaining generic-fallback gap into Task 31 and issue `#81`
- Delivery / Scrum: kept the sprint to one stderr path, one docs line, and tests
- Implementer: updated `bin/ai`, `docs/40-cli.md`, `test/ai_cli.sh`, and `test/repository_structure.sh`
- Reviewer / QA: no extra specialist changes were needed after the ordering and docs guard landed

## Retrospective Output

- keep
  - finishing consistency work by closing the broadest fallback surfaces, not only the happy paths
- change
  - add lightweight docs guards whenever a CLI recovery phrase becomes canonical
- stop
  - leaving generic fallback paths behind after stronger surfaces are cleaned up
- follow-ups
  - review top-level README wording again if the remaining foundation count needs another reduction sprint

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai`
  - `docs/40-cli.md`
  - `test/ai_cli.sh`
- rerun commands:
  - `bash test/ai_cli.sh`
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - if fallback wording changes later, the stderr order and docs guard should move together
