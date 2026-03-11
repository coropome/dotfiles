# Sprint

- issue: `#77`
- branch: `docs/77-ai-help-beginner-path`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex + Mendel
  - Docs / Onboarding specialist: Avicenna

## Compressed Memory

- goal: make `ai --help` a beginner-first discovery surface by showing the recommended next-step path before deeper commands
- decisions:
  - keep the main command catalog and workflow shortcut catalog intact
  - insert a short `First Steps` block with runtime repo, starter repo, and deeper-use paths
  - align `docs/40-cli.md` and `README.md` so `ai --help` is described as a beginner-path surface, not only a workflow-discovery surface
  - lock both line ordering and docs wording with tests so the guidance does not drift back into a flat catalog
- constraints:
  - stay within one turn-scoped sprint
  - avoid redesigning the overall CLI surface
  - keep deeper commands visible rather than hiding them behind a beginner-only mode
- current state: `ai --help` now shows first steps before workflow shortcuts, docs match that role, and ordering/docs drift are guarded
- next likely moves: inspect `ai doctor` and other high-traffic runtime messages for the same beginner-vs-deeper consistency pattern
- open questions: whether `ai --help` should eventually mention `make doctor` in the runtime repo path, or whether keeping that in docs/troubleshooting is clearer

## Lane Notes

- Product / Backlog: converted the next discovery-surface gap into Task 29 and issue `#77`
- Delivery / Scrum: kept the sprint to one high-traffic entrypoint plus docs/tests
- Implementer: updated `bin/ai`, `docs/40-cli.md`, `README.md`, `test/ai_cli.sh`, and `test/repository_structure.sh`
- Reviewer / QA: review feedback strengthened both the line-order assertions and the docs-side guidance contract

## Retrospective Output

- keep
  - making the highest-traffic surfaces tell the same story as the rest of the repo
- change
  - add stronger ordering assertions when the acceptance criteria are explicitly about ordered guidance
- stop
  - allowing docs/help consistency to rely on loose keyword checks only
- follow-ups
  - inspect `ai doctor` output next for beginner-path and next-step consistency

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `bin/ai`
  - `docs/40-cli.md`
  - `test/ai_cli.sh`
- rerun commands:
  - `bash test/ai_cli.sh`
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - if `ai --help` grows significantly, the first-steps block should stay short enough to remain a true entrypoint rather than another dense catalog
