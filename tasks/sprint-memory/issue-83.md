# Sprint

- issue: `#83`
- branch: `docs/83-ai-workflows-next-steps`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex + Mendel
  - Docs / Onboarding specialist: Avicenna

## Compressed Memory

- goal: make `ai workflows` a clearer bridge between workflow discovery and workspace launch
- decisions:
  - keep the existing workflow table and source path intact
  - append a compact `Next Steps` footer instead of redesigning the command
  - point to `ai-agent --describe --workflow <name>` before `ai start`
  - keep `ai doctor` as the diagnostic surface and avoid remediation logic here
- constraints:
  - stay within one turn-scoped sprint
  - keep the output short and terminal-friendly
  - preserve power-user discovery instead of hiding deeper inspection
- current state: `ai workflows` now ends with beginner-first next-step guidance, docs match the new bridge behavior, and tests cover the footer wording and order
- next likely moves: inspect whether README or quickstart need a follow-up mention if users still miss the workflow-inspection step
- open questions: whether `ai workflows` should eventually surface a shorter alias for `ai-agent --describe --workflow <name>`

## Lane Notes

- Product / Backlog: turned the next remaining beginner-path gap into Task 32 and issue `#83`
- Delivery / Scrum: kept the sprint to one CLI surface plus one docs line and tests
- Implementer: updating `bin/ai-agent`, `docs/40-cli.md`, `test/ai_cli.sh`, and `test/repository_structure.sh`
- Reviewer / QA: parallel review pointed to `ai workflows` as the highest-leverage remaining guided-flow gap

## Retrospective Output

- keep
  - closing guided beginner-path gaps in the order users actually hit them
- change
  - treat `ai workflows` as a bridge surface, not just metadata output
- stop
  - assuming a raw catalog is enough once a command becomes part of the canonical path
- follow-ups
  - inspect whether README or quickstart should mention the new `ai workflows` footer explicitly after the CLI contract lands

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai-agent`
  - `docs/40-cli.md`
  - `test/ai_cli.sh`
- rerun commands:
  - `bash test/ai_cli.sh`
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - if `ai workflows` output becomes longer later, the footer ordering tests should still keep inspection ahead of `ai start`
