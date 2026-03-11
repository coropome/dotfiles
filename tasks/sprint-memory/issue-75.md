# Sprint

- issue: `#75`
- branch: `docs/75-ai-start-guidance`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex + Mendel
  - Docs / Onboarding specialist: Avicenna

## Compressed Memory

- goal: align `ai start` workspace-ready guidance with the repo's beginner path so `ai doctor` and `ai workflows` come first after launch
- decisions:
  - keep `ai start` behavior unchanged and only adjust the ready message
  - split post-launch guidance into a beginner-first line and a deeper-commands line
  - test both output ordering and command success in the non-interactive path
  - add a docs-level guard so `docs/40-cli.md` cannot drift away from the same guidance
- constraints:
  - stay within one turn-scoped sprint
  - avoid interactive prompts or tmux layout changes
  - keep the message short and terminal-friendly
- current state: `ai start` now prints `Next: ai doctor | ai workflows` followed by deeper commands, and tests/docs guards are aligned
- next likely moves: continue tightening beginner-vs-deeper daily UX at the command surfaces that still reflect older wording
- open questions: whether `ai start` should eventually mention `ai code` / `ai review` as workflow aliases only, or keep `ai task` / `ai agents` equally visible

## Lane Notes

- Product / Backlog: converted the next beginner-path consistency gap into Task 28 and issue `#75`
- Delivery / Scrum: kept the sprint to message alignment, tests, and docs drift guards
- Implementer: updated `bin/ai-start`, `docs/40-cli.md`, `test/ai_cli.sh`, and `test/repository_structure.sh`
- Reviewer / QA: review feedback tightened the tests so `ai-start` must succeed and docs wording must stay aligned

## Retrospective Output

- keep
  - bringing runtime command messages back into the same path the docs already teach
- change
  - verify successful command completion in UX tests, not just strings
- stop
  - leaving older command lists in runtime output after onboarding guidance has moved on
- follow-ups
  - inspect other post-command messages for the same beginner/deeper split

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
  - if command surfaces are reworded later, docs and runtime output should move together to preserve the beginner-first guidance
