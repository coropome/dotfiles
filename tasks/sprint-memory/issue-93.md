# Sprint

- issue: `#93`
- branch: `docs/93-ai-doctor-backend-guidance`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: align ai-doctor next-step guidance with the current ai-start backend options
- decisions:
  - keep fail-case guidance focused on fixing reported gaps first
  - add the stdio alternative only to healthy and warn paths
  - keep the existing ai workflows first-step ordering
  - update docs and tests together because the footer wording is now part of the contract
- constraints:
  - do not weaken actual failure remediation
  - keep the footer short and terminal-friendly
  - avoid changing diagnostic content outside the next-step block
- current state: ai-doctor footer, CLI docs, and tests now mention the stdio alternative in healthy and warn cases, while fail cases stay focused on fixing gaps first
- next likely moves: run doctor and structure tests, then full verification and closeout
- open questions: whether a later sprint should make troubleshooting echo the new doctor footer wording more directly

## Lane Notes

- Product / Backlog: turned the post-#91 recovery-surface gap into Task 37 and issue `#93`
- Delivery / Scrum: kept the sprint to ai-doctor footer wording plus docs/tests
- Implementer: updating `bin/ai-doctor`, `docs/40-cli.md`, `test/ai_doctor.sh`, and `test/repository_structure.sh`
- Reviewer / QA: main risk is accidentally suggesting stdio in fail cases where users still need to fix workflow/config gaps first

## Retrospective Output

- keep
  - following launch-surface changes with recovery-surface updates in the next sprint
- change
  - treat ai-doctor footer lines as durable contract once they steer the beginner path
- stop
  - leaving doctor output on an older single-path story after ai-start changed
- follow-ups
  - consider tightening troubleshooting wording around the new doctor footer if it still feels implicit

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai-doctor`
  - `docs/40-cli.md`
  - `test/ai_doctor.sh`
- rerun commands:
  - `bash test/ai_doctor.sh`
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - fail-case guidance must not imply that backend selection can bypass real workflow/config failures
