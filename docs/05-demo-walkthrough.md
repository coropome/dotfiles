# Demo Walkthrough

この walkthrough は 10 分以内で AI Dev OS の基本フローを触るためのもの。

対象 fixture:

- [`demo/sample-project/README.md`](../demo/sample-project/README.md)

## 1. Open The Demo Repo

```bash
cd demo/sample-project
```

## 2. Start The Workspace

```bash
ai start --repo "$(pwd)"
```

期待すること:

- tmux workspace が起動する
- context pane が開く
- repo-local `.ai-dev-os/` 設定が使われる

## 3. Inspect Available Workflows

```bash
ai workflows
ai agents
```

## 4. Run A Review Flow

```bash
ai review --help
```

## 5. Run Prompt Evaluation

```bash
ai eval review
```

## 6. Explore The Fixture

- `.ai-dev-os/agents.yml`
- `.ai-dev-os/workflows.yml`
- `prompts/review.prompt.yml`

## Notes

- この fixture は `ai init` が生成する starter と同期させる
- sync check は `test/demo_assets.sh` で行う
