# Sprint

- issue: `#95`
- branch: `docs/95-ai-help-backend-guidance`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: align `ai --help` with the current `ai start` backend options
- decisions:
  - keep the first-steps block compact and terminal-friendly
  - place the backend note between the runtime and starter paths
  - describe `tmux` as the current default and `stdio` as the lighter alternative
  - update docs and ordering guards together because help output is now part of the backend contract
- constraints:
  - do not bloat `ai --help` into a long tutorial
  - preserve the beginner-first ordering already introduced in help output
  - keep wording consistent with `ai start`, `ai init`, and `ai doctor`
- current state: `ai --help`, CLI docs, and tests now expose the backend note in the first-steps block without changing the broader command catalog shape
- next likely moves: verify help and structure tests, then full verification and closeout
- open questions: whether a later sprint should surface the backend contract in `ai workflows` or keep that output narrower

## Lane Notes

- Product / Backlog: turned the remaining high-traffic CLI discovery gap into Task 38 and issue `#95`
- Delivery / Scrum: kept the sprint to help output, docs, and guards
- Implementer: updating `bin/ai`, `docs/40-cli.md`, `test/ai_cli.sh`, and `test/repository_structure.sh`
- Reviewer / QA: main risk is disturbing the current first-step ordering while adding the backend note

## Retrospective Output

- keep
  - following backend changes through the most visible CLI surfaces first
- change
  - treat `ai --help` lines as durable contract once they teach the beginner path
- stop
  - relying on deeper docs to carry backend nuance while help output stays ambiguous
- follow-ups
  - consider whether troubleshooting should explicitly reference the help-level backend note or stay focused on `ai start` and `ai doctor`

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
  - first-step ordering must remain runtime -> backend -> starter -> deeper
