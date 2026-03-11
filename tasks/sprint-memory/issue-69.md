# Sprint

- issue: `#69`
- branch: `docs/69-plans-closeout-contract`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex + Mendel
  - Docs / Onboarding specialist: Avicenna

## Compressed Memory

- goal: define a minimal `PLANS.md` closeout contract so turn-scoped sprints do not leave stale active-plan metadata behind
- decisions:
  - keep the contract docs-first and grep-guarded
  - use canonical `Sprint Status`, `Sprint Scope`, `Memory Artifact`, and `Resume Point` fields in `PLANS.md`
  - require `## Closeout` for closed turn-scoped sprints
  - make memory handoff explicit as either a concrete artifact path or `not needed in this sprint`
- constraints:
  - stay within one turn-scoped sprint
  - avoid adding automation that rewrites `PLANS.md`
  - avoid a new ADR unless the current cadence docs are insufficient
- current state: docs, plan surface, sprint-memory guidance, and structure tests are aligned on the closeout contract
- next likely moves: start the next sprint from a new issue-backed branch; do not reopen this plan
- open questions: whether a future sprint should add a reusable `PLANS.md` template generator or leave the contract docs-only

## Lane Notes

- Product / Backlog: converted the next operating-model gap into Task 25 and issue `#69`
- Delivery / Scrum: kept this sprint to one docs-and-guards slice and closed it in-turn
- Implementer: updated `docs/93-scrum-delivery.md`, `PLANS.md`, `tasks/sprint-memory/README.md`, and `test/repository_structure.sh`
- Reviewer / QA: used specialist feedback to keep the contract small and testable, centered on stale-plan prevention

## Retrospective Output

- keep
  - converting collaboration habits into repo artifacts and guards
- change
  - define plan closeout state directly instead of relying on implied merge completion
- stop
  - treating `PLANS.md` as implicitly current after a sprint has already ended
- follow-ups
  - consider whether future plan ergonomics need a dedicated reusable template or helper

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `docs/93-scrum-delivery.md`
  - `PLANS.md`
  - `tasks/sprint-memory/README.md`
- rerun commands:
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - grep-based guards depend on stable canonical labels, so future wording edits should preserve those labels
