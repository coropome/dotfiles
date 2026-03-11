# AGENTS.md

This is the repository-wide master instruction file for coding agents.

Compatibility files such as `CLAUDE.md`, `GEMINI.md`, or `.github/copilot-instructions.md` may point here or summarize the same rules, but this file is the source of truth for this repository.

Keep this file short. Put durable detail in normal repository docs and link to them from here.

## Scope And Precedence

- This file applies to the entire repository unless a deeper `AGENTS.md` overrides part of the tree.
- If a more specific `AGENTS.md` exists in a subdirectory, follow the nearest in-scope file for files under that subtree.
- Agent-specific compatibility files should not drift from this file.

## Read Before Work

Before planning or editing, read:

- [`docs/92-development-workflow.md`](./docs/92-development-workflow.md)
- [`docs/40-cli.md`](./docs/40-cli.md)
- [`docs/41-ai-trust.md`](./docs/41-ai-trust.md)
- [`tasks/backlog.md`](./tasks/backlog.md)

If the task changes architecture or long-term operating rules, also read:

- [`docs/adr/README.md`](./docs/adr/README.md)

## Mandatory Workflow

- Do not start implementation without a GitHub Issue.
- If no issue exists:
  - capture or refine the idea in [`tasks/backlog.md`](./tasks/backlog.md)
  - create the GitHub Issue
  - write clear acceptance criteria in the issue
  - then implement
- Use an issue-linked branch:
  - `feat/<issue>-short-name`
  - `fix/<issue>-short-name`
  - `docs/<issue>-short-name`
  - `chore/<issue>-short-name`
- Link the PR back to the issue with `Closes #<issue>`.

## How To Work In This Repo

- Prefer config-driven behavior over hardcoded vendor branches.
- Prefer vendor-native features over shell reimplementation.
  - Use AI Dev OS config for routing and repo policy:
    - `.ai-dev-os/workflows.yml`
    - `.ai-dev-os/agents.yml`
  - Use vendor-native config for vendor behavior:
    - `.claude/settings.json`
    - `.claude/agents/`
    - `~/.codex/config.toml`
    - `~/.gemini/settings.json`
- Keep beginner UX simple.
- Keep tmux internal when possible; user-facing commands should stay high level.
- Update docs when behavior changes.
- Add or update tests with every behavior change.

## Security And Trust

- Use least privilege by default.
- Keep filesystem access project-scoped unless the task explicitly requires more.
- Treat network access, destructive shell commands, secrets, and external MCP servers as high risk.
- Prefer documented trust-policy templates under [`templates/ai-trust/`](./templates/ai-trust/).
- Never loosen trust settings silently.

## Plans For Long Work

When the task is large, ambiguous, or expected to take multiple meaningful steps, create or update a plan document before major edits.

- Put plans in `PLANS.md` or `docs/adr/` when appropriate.
- A good plan is self-contained, outcome-focused, and kept up to date as work progresses.
- If a task is too large for one pass, leave the plan in a restartable state for the next agent.

## Completion Checklist

Before marking work done:

- issue exists and matches the work
- acceptance criteria are satisfied or updated
- docs changed if behavior changed
- `make test` passes
- `make lint` passes
- working tree is clean except for intentional changes

## Pointers

- Workflow rules: [`docs/92-development-workflow.md`](./docs/92-development-workflow.md)
- CLI and config boundaries: [`docs/40-cli.md`](./docs/40-cli.md)
- Trust defaults: [`docs/41-ai-trust.md`](./docs/41-ai-trust.md)
- ADR rules: [`docs/adr/README.md`](./docs/adr/README.md)
- Backlog: [`tasks/backlog.md`](./tasks/backlog.md)
