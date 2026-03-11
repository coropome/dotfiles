# Sprint

- issue: `#85`
- branch: `docs/85-terminal-orchestration-modes`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex
  - Architecture lane: external official docs + local repo audit

## Compressed Memory

- goal: decide whether tmux is part of the long-term AI Dev OS product boundary or only the current workspace backend
- decisions:
  - keep tmux as the current default backend for `ai start`
  - do not treat tmux as the AI Dev OS control plane or north-star surface
  - classify Ghostty / WezTerm / similar tools as terminal-native frontend integrations, not the system core
  - require a future workspace backend adapter before adding alternative launch modes
- constraints:
  - do not claim tmux is optional today for `ai start`
  - keep the beginner path stable while redefining the architecture boundary
  - keep follow-up implementation work out of this ADR sprint
- current state: ADR and supporting docs now define tmux as the current backend rather than the AI Dev OS core; follow-up implementation work is captured as Task 34
- next likely moves: add the follow-up implementation task for a backend adapter, then decide whether the first alternative mode should be `stdio` or a terminal-native integration
- open questions: whether the first post-tmux experiment should optimize for persistence (`tmux` parity) or for terminal-native UX

## Lane Notes

- Product / Backlog: converted the user concern into a decision issue plus a concrete implementation follow-up
- Delivery / Scrum: kept the sprint to architecture and documentation, not a backend rewrite
- Implementer: updating ADR, philosophy, ownership, support docs, and repo guards
- Architecture lane: local audit showed tmux is currently mandatory in `bin/ai-start`; official docs suggest Ghostty is attractive as a frontend but not a durable session backend

## Retrospective Output

- keep
  - forcing a clean architecture decision before swapping execution backends
- change
  - make current implementation requirements explicit without elevating them into the product north star
- stop
  - letting backend choice leak into the control-plane identity
- follow-ups
  - implement a workspace backend adapter in a separate issue

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: updated

## Handoff

- read first:
  - `bin/ai-start`
  - `docs/90-philosophy.md`
  - `docs/91-state-ownership.md`
  - `docs/adr/0006-terminal-orchestration-modes.md`
- rerun commands:
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - docs must stay precise that tmux is still required today for `ai start`, otherwise the architecture decision will read like an implementation claim
