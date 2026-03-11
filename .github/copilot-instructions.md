# Repository Instructions

Use [`AGENTS.md`](../AGENTS.md) as the repository-wide source of truth for agent behavior.

Required rules:

- do not implement without a GitHub Issue
- follow [`docs/92-development-workflow.md`](../docs/92-development-workflow.md)
- for multi-step work, follow [`docs/93-scrum-delivery.md`](../docs/93-scrum-delivery.md)
- for multi-agent or handoff-heavy work, leave compressed memory under [`tasks/sprint-memory/`](../tasks/sprint-memory/)
- prefer config-driven behavior over vendor-specific shell branching
- update docs and tests with behavior changes
- run `make test` and `make lint` before considering work complete
