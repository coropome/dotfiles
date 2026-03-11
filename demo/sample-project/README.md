# Sample Project

Tiny fixture for demonstrating the staged AI Dev OS adoption flow.

## Stage 1: inspect the local starter first

```bash
sed -n '1,200p' .ai-dev-os/README.md
ai doctor
```

Use this stage to confirm:

- the repo-local starter is present
- workflow / prompt / trust / fallback issues are visible through `ai doctor`
- you are still on the local-first path before debugging CI or runtime pinning

## Stage 2: inspect the local workflow surface

```bash
ai workflows
ai agents
ai-agent --describe --workflow review
```

Use this stage to see which workflow and agent metadata the fixture exposes before opening the workspace.

## Stage 3: start the workspace

```bash
ai start --repo demo/sample-project
```

Expected result:

- a tmux-based AI Dev OS workspace opens
- repo-local `.ai-dev-os/` config is used
- the context pane is refreshed for this fixture

## Stage 4: optional prompt check

```bash
ai eval review
```

Keep this secondary. The main demo path is still `starter README -> ai doctor -> ai workflows -> ai start`.

## If something fails

- local onboarding problem
  - use `ai doctor`
- CI or runtime pinning problem
  - use the current AI Dev OS runtime repo's `docs/42-github-actions.md`
- system or bootstrap problem
  - run `make doctor` from the AI Dev OS runtime repo

## Notes

- this fixture mirrors what `ai init` generates
- local-only / PR CI / hosted eval adoption stays secondary to the local-first path
- the deeper walkthrough lives in `docs/05-demo-walkthrough.md`
