# Sprint

- issue: `#53`
- branch: `docs/53-retro-memory-loop`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Explorer / Design: Gibbs
  - Explorer / Guardrails: Hypatia

## Compressed Memory

- goal:
  - make retrospectives update the operating system and preserve compressed agent memory
- decisions:
  - use `tasks/sprint-memory/` as the durable location for compressed sprint memory
  - keep `PLANS.md` as the live active-work document, not the long-term handoff store
  - default to compressed summaries, with raw coordination logs optional under `tasks/sprint-memory/raw/`
- constraints:
  - keep the process lightweight for small changes
  - do not make full chat transcript retention the default
  - preserve issue-first and test-guarded workflow rules
- current state:
  - issue exists
  - Scrum docs are being updated to add retrospective feedback loops and memory artifact rules
  - active plan is aligned to issue `#53` and points to this artifact
- next likely moves:
  - finish normalizing wording and tests around `tasks/sprint-memory/`
  - verify guard coverage with `make lint` and `make test`
- open questions:
  - whether to keep a sample artifact permanently or rely only on the README contract

## Lane Notes

- Product / Backlog
  - converted the idea into Task 21 and issue `#53`
- Delivery / Scrum
  - using the new Scrum cadence to drive the follow-up itself
- Explorer / Design
  - recommended separating live planning from durable compressed memory
- Explorer / Guardrails
  - still pending at the time this artifact was first written

## Retrospective Output

- keep
  - tie new operating rules to grep-based tests so they do not disappear
- change
  - standardize memory artifact placement before more branches invent new paths
- stop
  - relying on free-form plan notes as the only handoff surface
- follow-ups
  - consider whether PR templates should eventually link sprint memory artifacts directly

## System Updates

- backlog: `updated`
- plans: `updated`
- docs: `updated`
- tests: `updated`
- instructions: `updated`
- ADR: `updated`

## Handoff

- read first:
  - `docs/93-scrum-delivery.md`
  - `PLANS.md`
  - `test/repository_structure.sh`
- rerun commands:
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - wording and tests must stay on `tasks/sprint-memory/` only; mixed paths would break the handoff contract
