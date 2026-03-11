# Sprint

- issue: `#91`
- branch: `docs/91-ai-init-backend-guidance`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: align generated starter guidance with the current `ai start` backend options
- decisions:
  - keep `tmux` as the current default story in generated artifacts
  - expose `stdio` as the lighter alternative in starter README and init output
  - avoid changing onboarding order or overloading the starter with advanced terminal detail
  - keep demo fixture identical to generated output
- constraints:
  - stay focused on generated surfaces
  - do not change ai-start behavior
  - preserve local-first adoption wording
- current state: `ai init` output and generated starter README now reflect tmux default plus stdio alternative, and fixture sync confirms the final content
- next likely moves: run ai-init, demo, and structure tests, then full verification and closeout
- open questions: whether a later sprint should mention backend-aware `ai start` in generated starter GitHub Actions notes too

## Lane Notes

- Product / Backlog: turned the post-#89 starter gap into Task 36 and issue `#91`
- Delivery / Scrum: kept the sprint to generated output, fixture sync, and tests
- Implementer: updating `bin/ai-init`, demo starter README, and init/structure tests
- Reviewer / QA: main risk is drifting the generated fixture away from actual ai-init output

## Retrospective Output

- keep
  - treating generated starter artifacts as part of the beginner-facing product surface
- change
  - follow top-level docs with scaffold/output alignment immediately after contract changes
- stop
  - assuming fixture sync alone is enough without wording assertions in ai-init tests
- follow-ups
  - consider backend-aware guidance in more generated starter artifacts if new backends appear

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai-init`
  - `demo/sample-project/.ai-dev-os/README.md`
  - `test/ai_init.sh`
- rerun commands:
  - `bash test/ai_init.sh`
  - `bash test/demo_assets.sh`
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - the generated README and demo fixture must remain byte-for-byte aligned after wording changes
