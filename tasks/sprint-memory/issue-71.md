# Sprint

- issue: `#71`
- branch: `docs/71-plans-template`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex + Mendel
  - Docs / Onboarding specialist: Avicenna

## Compressed Memory

- goal: add a reusable `PLANS.md` template so turn-scoped and intentionally multi-turn sprints start from the canonical shape
- decisions:
  - keep the solution as a repo template, not a CLI generator
  - place the reusable asset at `templates/plans/PLANS.md`
  - keep `docs/93-scrum-delivery.md` as the rule source and point it to the template as the recommended starting shape
  - guard the template with narrow structure checks for the canonical plan fields and closeout section
- constraints:
  - stay within a one-turn docs-and-guards sprint
  - avoid adding automation or another planning surface
  - keep the template small enough to guide without turning into process bloat
- current state: template, docs link, and guards are aligned on the canonical plan shape
- next likely moves: next sprint can start by copying `templates/plans/PLANS.md` into `PLANS.md` and filling only the current issue slice
- open questions: whether future ergonomics justify a helper command, or whether the template should remain the stable manual path

## Lane Notes

- Product / Backlog: converted the next plan ergonomics gap into Task 26 and issue `#71`
- Delivery / Scrum: kept the sprint to one reusable asset plus docs/test integration
- Implementer: added `templates/plans/PLANS.md`, connected it from `docs/93-scrum-delivery.md`, and guarded it in `test/repository_structure.sh`
- Reviewer / QA: specialist feedback favored a minimal template over heavier automation

## Retrospective Output

- keep
  - turning repeated sprint behavior into durable repo assets
- change
  - provide a starting template before contributors need to hand-copy the previous plan
- stop
  - treating the last `PLANS.md` as the only bootstrap mechanism for the next sprint
- follow-ups
  - consider whether a future helper should scaffold `PLANS.md` from this template, but only if manual copying becomes a real drag

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `templates/plans/PLANS.md`
  - `docs/93-scrum-delivery.md`
  - `PLANS.md`
- rerun commands:
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - the template must stay canonical but lightweight; future edits should preserve the short field set and closeout shape
