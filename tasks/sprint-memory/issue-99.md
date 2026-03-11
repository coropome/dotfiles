# Sprint

- issue: `#99`
- branch: `docs/99-ai-start-help-backend-contract`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: align `ai-start --help` with the current backend choice contract
- decisions:
  - keep the help output compact and terminal-friendly
  - describe `tmux` as the current default and `stdio` as the lighter alternative
  - mention `AI_WORKSPACE_BACKEND=stdio` in help because it is part of the public backend contract
  - update docs and ordering guards together because help output is now a durable discovery surface
- constraints:
  - do not turn `ai-start --help` into a long tutorial
  - do not imply that `stdio` replaces `tmux` as the default
  - keep wording consistent with `ai --help`, `ai doctor`, and `docs/40-cli.md`
- current state: `ai-start --help`, CLI docs, and tests now expose the tmux default, stdio alternative, and env override in a compact form
- next likely moves: verify CLI and structure tests, then decide whether the remaining demo README drift is worth another sprint
- open questions: whether the demo sample-project README should mirror the backend language more explicitly

## Lane Notes

- Product / Backlog: turned the remaining command-specific help gap into Task 40 and issue `#99`
- Delivery / Scrum: kept the sprint to one help surface plus matching docs/tests
- Implementer: updating `bin/ai-start`, `docs/40-cli.md`, `test/ai_cli.sh`, and `test/repository_structure.sh`
- Reviewer / QA: main risk is bloating help text or making the backend hierarchy less clear

## Retrospective Output

- keep
  - following backend changes through the most local discovery surface for each command
- change
  - treat command help as part of the durable product contract once users depend on it for option discovery
- stop
  - leaving backend choice implicit in command help after other docs have already made it explicit
- follow-ups
  - consider the demo README backend wording if the top-level sample still reads too tmux-only

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai-start`
  - `docs/40-cli.md`
  - `test/ai_cli.sh`
- rerun commands:
  - `bash test/ai_cli.sh`
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - help text must stay short while still making the backend default and env override explicit
