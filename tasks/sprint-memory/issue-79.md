# Sprint

- issue: `#79`
- branch: `docs/79-ai-doctor-next-steps`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex + Mendel
  - Docs / Onboarding specialist: Avicenna

## Compressed Memory

- goal: make `ai doctor` end with beginner-first next-step guidance so diagnosis leads to the right next action
- decisions:
  - keep existing diagnostics unchanged and append a compact `Next Steps` footer
  - use three outcomes: healthy, warn, fail
  - healthy: `ai workflows -> ai start`
  - warn: `ai workflows -> optional ai-agent --describe --workflow <name> -> ai start`
  - fail: `fix the reported gaps above -> rerun ai doctor -> ai workflows`
  - treat the final footer lines as part of the contract and test them as end-of-output behavior
- constraints:
  - stay within one turn-scoped sprint
  - do not blur `ai doctor` and `make doctor`
  - do not imply that `ai doctor` fixes problems automatically
- current state: `ai doctor` now ends with outcome-based next steps, docs match the three cases, and tests cover healthy/warn/fail ordering plus footer placement
- next likely moves: inspect whether `make doctor` and troubleshooting docs need a similar compact outcome summary without collapsing the AI-vs-host boundary
- open questions: whether warn output should eventually name the selected workflow more prominently when no fallback was involved

## Lane Notes

- Product / Backlog: converted the next recovery-surface gap into Task 30 and issue `#79`
- Delivery / Scrum: kept the sprint to one diagnostic surface, one docs line, and tests
- Implementer: updated `bin/ai-doctor`, `docs/40-cli.md`, `test/ai_doctor.sh`, and `test/repository_structure.sh`
- Reviewer / QA: review feedback strengthened both footer placement checks and warn/fail docs coverage

## Retrospective Output

- keep
  - aligning the highest-traffic runtime surfaces one by one against the same beginner path
- change
  - test footer placement explicitly when the feature is “what happens at the end”
- stop
  - letting diagnostic commands end without a clear recovery or next-step path
- follow-ups
  - inspect `make doctor` and troubleshooting surfaces next for the same outcome-summary gap

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
  - if diagnostic statuses or wording change later, the footer rules and end-of-output assertions need to move together
