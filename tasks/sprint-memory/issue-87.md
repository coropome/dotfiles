# Sprint

- issue: `#87`
- branch: `feat/87-ai-start-backend-adapter`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex
  - QA specialist: Kepler
  - Exploration specialist: Hypatia

## Compressed Memory

- goal: add a narrow workspace backend adapter to `ai start` so tmux stays default without remaining the only path
- decisions:
  - keep `tmux` as the default backend
  - add `stdio` as the first alternative backend
  - support both `--backend stdio` and `AI_WORKSPACE_BACKEND=stdio`
  - keep the beginner guidance identical across backends
- constraints:
  - do not break current tmux-backed behavior
  - do not introduce terminal-native integrations in this sprint
  - keep docs explicit that tmux is still the current default
- current state: `ai start` now supports backend selection, keeps tmux as default, and offers a stdio backend that works without tmux
- next likely moves: finish verification, then close and merge
- open questions: whether `stdio` should eventually print a stronger hint for terminal-native follow-up integrations

## Lane Notes

- Product / Backlog: implemented the follow-up promised by ADR 0006
- Delivery / Scrum: kept the sprint to one backend abstraction and one alternative mode
- Implementer: updating `bin/ai-start`, CLI docs, support docs, and tests
- Reviewer / QA: main risk is drift between the default tmux path and the non-tmux contract

## Retrospective Output

- keep
  - proving architectural flexibility with a small runnable alternative
- change
  - test non-default backend paths explicitly once a command gains a backend selector
- stop
  - assuming the default backend contract is enough coverage
- follow-ups
  - evaluate whether the next backend should be terminal-native or another non-attached mode

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
  - default tmux behavior and stdio behavior must stay aligned on the same beginner guidance while keeping different backend requirements
