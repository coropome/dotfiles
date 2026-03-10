# AI Dev OS Backlog

## Task 1

Title: Promote `ai start` to the primary beginner entrypoint

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

Problem:
The OS abstraction layer exists, but install and service behavior are still minimal outside macOS.

Improvement Idea:
Add explicit package maps, clipboard fallbacks, and clearer remediation for Linux/WSL.

Implementation Hint:
Teach `os/linux.sh` and `os/wsl.sh` to cover more package managers and runtime checks.

Expected Impact:
More of the AI Dev OS workflow works outside macOS.
