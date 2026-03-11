# Sprint

- issue: `#97`
- branch: `feat/97-ai-start-stdio-recovery`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: align the direct `ai start` tmux-missing failure path with the current backend options
- decisions:
  - keep tmux as the default backend and keep its install remediation visible
  - add the stdio alternative only when the failure is specifically about missing tmux
  - treat stderr guidance as part of the backend contract once it teaches a fallback
  - keep the wording short and terminal-friendly
- constraints:
  - do not weaken the current tmux remediation
  - do not imply that stdio replaces tmux as the default
  - avoid broad restructuring of `ai-start`
- current state: `ai-start` now mentions `ai start --backend stdio` on tmux-missing failures, and docs/tests lock the wording down
- next likely moves: verify CLI and structure tests, then decide whether any backend-aware edge surfaces still remain
- open questions: whether future backends should share a more general missing-backend remediation contract

## Lane Notes

- Product / Backlog: turned the remaining launch-recovery gap into Task 39 and issue `#97`
- Delivery / Scrum: kept the sprint to one stderr contract plus matching docs/tests
- Implementer: updating `bin/ai-start`, `docs/40-cli.md`, `test/ai_cli.sh`, and `test/repository_structure.sh`
- Reviewer / QA: main risk is over-suggesting stdio in contexts where tmux remediation should stay primary

## Retrospective Output

- keep
  - following backend changes through the most direct user-facing failure surfaces
- change
  - treat launch stderr as durable contract when it teaches fallback paths
- stop
  - assuming troubleshooting docs are enough while the direct failure path still looks stricter than the product is
- follow-ups
  - consider whether future backend adapters need a shared remediation helper once more than two backends exist

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
  - tmux remediation must remain visible and primary even after adding the stdio fallback
