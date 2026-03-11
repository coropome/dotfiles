# Sprint

- issue: `#101`
- branch: `docs/101-demo-readme-backend-guidance`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: align the demo sample-project README with the current `ai start` backend contract
- decisions:
  - keep the staged demo flow unchanged
  - describe `tmux` as the current default backend in Stage 3
  - mention `ai start --repo demo/sample-project --backend stdio` as the lighter non-tmux alternative
  - update demo and structure guards together because the sample README is now part of the backend contract
- constraints:
  - do not rewrite the whole demo README
  - preserve the local-first stage ordering
  - keep wording consistent with the starter README and walkthrough
- current state: the demo README, demo asset test, and structure guard now expose the tmux-default plus stdio-alternative story directly in Stage 3
- next likely moves: verify demo and structure tests, then decide whether any remaining foundation drift is worth another sprint
- open questions: whether the foundation phase is complete enough to switch fully into expansion work after this slice

## Lane Notes

- Product / Backlog: turned the remaining demo-surface drift into Task 41 and issue `#101`
- Delivery / Scrum: kept the sprint to one sample README plus matching guards
- Implementer: updating `demo/sample-project/README.md`, `test/demo_assets.sh`, and `test/repository_structure.sh`
- Reviewer / QA: main risk is drifting from the already-aligned walkthrough or starter README wording

## Retrospective Output

- keep
  - following backend changes through every newcomer-facing surface, including fixtures
- change
  - treat the demo README as contract once it acts as the sample staged-adoption entrypoint
- stop
  - assuming the walkthrough is enough while the sample README still reads more rigidly
- follow-ups
  - decide whether the foundation phase is now complete or if one more polish sprint is still justified

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `demo/sample-project/README.md`
  - `test/demo_assets.sh`
  - `test/repository_structure.sh`
- rerun commands:
  - `bash test/demo_assets.sh`
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - the Stage 3 wording must stay aligned with the walkthrough and starter README without over-explaining
