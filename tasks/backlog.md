# AI Dev OS Backlog

## Task 1

Title: Promote `ai start` to the primary beginner entrypoint
Tracking: #1

Problem:
The repo still exposes multiple bootstrap commands that assume shell and tmux knowledge.

Improvement Idea:
Make `ai start` the first-class workflow for opening a ready AI workspace.

Implementation Hint:
Expand `bin/ai-start` so it validates dependencies, builds context, and opens a richer pane layout.

Expected Impact:
Beginners can start productive work with one command.

## Task 2

Title: Add role-aware agent launching
Tracking: #2

Problem:
The current scaffold maps workflow names to tools, but not to prompt files or startup instructions.

Improvement Idea:
Bind agent roles to prompts and startup commands so `ai agent reviewer` behaves differently from `ai agent implementer`.

Implementation Hint:
Extend `ai/agents.yml` and `bin/ai` to expose prompt metadata and default flags per role.

Expected Impact:
Multi-agent workflows become more repeatable.

## Task 3

Title: Expand Linux and WSL compatibility layer
Tracking: #6

Problem:
The OS abstraction layer exists, but install and service behavior are still minimal outside macOS.

Improvement Idea:
Add explicit package maps, clipboard fallbacks, and clearer remediation for Linux/WSL.

Implementation Hint:
Teach `os/linux.sh` and `os/wsl.sh` to cover more package managers and runtime checks.

Expected Impact:
More of the AI Dev OS workflow works outside macOS.

## Task 4

Title: Prefer native MCP and settings over wrapper reimplementation
Tracking: #3

Problem:
Modern AI CLIs increasingly expose MCP, hooks, and local settings directly, but the current scaffold still trends toward wrapper logic.

Improvement Idea:
Treat Claude, Codex, and Gemini as native runtimes and let AI Dev OS orchestrate them through config discovery instead of feature-by-feature shell code.

Implementation Hint:
Support project-level `.ai-dev-os/agents.yml` and `.ai-dev-os/workflows.yml`, surface each agent's native config files, and keep vendor-specific behavior in `.claude/`, `.codex/`, or `~/.gemini/` rather than in `bin/`.

Expected Impact:
When vendors add MCP servers, hooks, headless flags, or subagent features, users can adopt them mostly through config changes.

## Task 5

Title: Add prompt artifacts and evals as first-class repo assets
Tracking: #4

Problem:
Prompt iteration is still implicit in Markdown files, which makes regression testing and cross-model comparison weak.

Improvement Idea:
Store reusable prompts and evaluation datasets in repo-native files so they can run in CI and in GitHub Models without custom tooling.

Implementation Hint:
Add `.prompt.yml` files under `prompts/` and wire `gh models eval` into an optional `ai eval` flow.

Expected Impact:
Prompt quality becomes reviewable, repeatable, and easier to compare across vendors and model upgrades.

## Task 6

Title: Ship trust policies for MCP and autonomous agents
Tracking: #5

Problem:
MCP and agentic coding features increase capability, but also raise the risk of over-broad permissions and unsafe network access.

Improvement Idea:
Define opinionated project templates for allowed MCP servers, filesystem scopes, and internet access so beginners get safe defaults.

Implementation Hint:
Generate starter config for `.claude/settings.json`, `~/.codex/config.toml`, and `.gemini/settings.json` with documented permission boundaries and per-project overrides.

Expected Impact:
Users can adopt powerful new AI features with fewer security surprises.
