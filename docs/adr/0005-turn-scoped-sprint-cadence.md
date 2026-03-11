# 0005 Turn-Scoped Sprint Cadence

- Status: Accepted
- Date: 2026-03-11

## Context

AI Dev OS now has Scrum delivery rules and sprint-memory artifacts, but the practical cadence of this collaboration can still be interpreted loosely.
Without an explicit default, a user turn might behave like an arbitrary fragment of a sprint instead of a complete sprint slice with planning, execution, review/demo, and retrospective.

## Decision

For this collaboration mode, default to treating one user/assistant round-trip as one sprint.

Specifically:

- each turn should normally include sprint planning, execution, review/demo, and retrospective
- agents are responsible for running that cadence inside the turn
- an issue may intentionally span multiple turns only when the work explicitly justifies it
- small changes may still use the minimal-ceremony escape hatch already defined by the Scrum docs

## Consequences

- collaboration cadence becomes predictable to both user and agents
- sprint closeout is expected at the end of each turn by default
- multi-turn work needs to say why it remains open instead of drifting implicitly
- agents must be more deliberate about sprint boundaries and closeout evidence
