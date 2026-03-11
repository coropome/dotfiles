# Sprint

- issue: `#89`
- branch: `docs/89-ai-start-backend-docs`
- date: `2026-03-11`
- lanes:
  - Product / Backlog: Codex
  - Delivery / Scrum: Codex
  - Implementer: Codex
  - Reviewer / QA: Codex

## Compressed Memory

- goal: align newcomer-facing docs and troubleshooting with the current `ai start` backend options
- decisions:
  - keep `tmux` as the current default story
  - expose `stdio` as the lighter alternative when terminal choice should stay flexible
  - avoid changing the beginner path ordering
  - keep tmux-specific deep docs unchanged in this sprint
- constraints:
  - stay on high-traffic docs only
  - do not redesign backend behavior
  - keep wording clear that stdio is an alternative, not the new default
- current state: README, quickstart, demo walkthrough, and troubleshooting now reflect tmux default plus stdio alternative, and guards lock the wording
- next likely moves: run demo and structure guards, then full verification and closeout
- open questions: whether the next docs sprint should add `stdio` examples to generated starter README as well

## Lane Notes

- Product / Backlog: turned the post-#87 docs gap into Task 35 and issue `#89`
- Delivery / Scrum: kept the sprint to top-level docs and guards
- Implementer: updating README, quickstart, demo walkthrough, troubleshooting, and tests
- Reviewer / QA: main risk is introducing stdio wording without preserving tmux as the default path

## Retrospective Output

- keep
  - following behavior changes with docs alignment in the next sprint
- change
  - treat troubleshooting and demo docs as first-class beginner-path surfaces
- stop
  - leaving top-level docs one sprint behind the actual entrypoint contract
- follow-ups
  - decide whether generated starter README should mention the stdio option explicitly

## System Updates

- backlog: updated
- plans: updated
- docs: updated
- tests: updated
- instructions: not needed
- ADR: not needed

## Handoff

- read first:
  - `README.md`
  - `docs/00-quickstart.md`
  - `docs/05-demo-walkthrough.md`
  - `docs/99-troubleshooting.md`
- rerun commands:
  - `bash test/demo_assets.sh`
  - `bash test/repository_structure.sh`
  - `make lint`
  - `make test`
- known risks:
  - wording must keep `tmux` as default while still making `stdio` discoverable enough to matter
