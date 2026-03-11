# 0004 AI Dev OS Retrospective Feedback And Sprint Memory

- Status: Accepted
- Date: 2026-03-11

## Context

AI Dev OS now has a Scrum cadence, but retrospective output can still die as a note instead of improving the operating system.
At the same time, multi-agent work is exposed to context loss, handoff gaps, and memory compression artifacts that may vanish once a session ends.

The repo needs a durable rule for:

- turning retrospective output into concrete system updates
- preserving compressed handoff context without defaulting to full raw chat transcript storage

## Decision

AI Dev OS will treat retrospective output as a system-update trigger and store compressed sprint memory artifacts under `tasks/sprint-memory/`.

Specifically:

- retrospectives must map to backlog, plans, docs, tests, instructions, ADR, or explicit no-op
- `PLANS.md` remains the live active-work document
- compressed sprint memory becomes the durable handoff artifact
- raw coordination logs are optional and only kept when compressed memory is insufficient
- the directory and wording are guarded in repository structure tests

## Consequences

- multi-agent work becomes easier to resume after context loss or handoff
- operating rules can improve sprint by sprint instead of relying on tribal memory
- the repo avoids making full transcript retention the default
- contributors need to maintain one more durable artifact for longer-running work
