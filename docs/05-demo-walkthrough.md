# Demo Walkthrough

この walkthrough は 10 分以内で AI Dev OS の基本フローを触るためのもの。

対象 fixture:

- [`demo/sample-project/README.md`](../demo/sample-project/README.md)

## 1. Open The Demo Repo

```bash
cd demo/sample-project
```

## 2. Inspect The Demo README First

```bash
sed -n '1,200p' README.md
```

期待すること:

- demo repo 自体が staged adoption flow を案内している
- local-first path が top-level entrypoint になっている
- generated starter README と walkthrough の間に役割のズレがない

## 3. Inspect The Local Starter First

Stage 1: local onboarding を先に固める。

```bash
sed -n '1,200p' .ai-dev-os/README.md
ai doctor
```

期待すること:

- generated starter が local-first path を案内している
- `ai doctor` が repo-local workflow / prompt / trust / fallback を見せる
- 困り方が local onboarding なのか CI/runtime なのか切り分けられる

## 4. Inspect Available Workflows

Stage 2: local workflow の見え方を確認する。

```bash
ai workflows
ai agents
ai-agent --describe --workflow review
```

local-only path を先に固める前提で見る。CI や hosted eval はこの fixture を触ったあとに必要になってから足す。
ここで fallback chain や prompt metadata の見え方も確認しておく。

## 5. Start The Workspace

```bash
ai start --repo "$(pwd)"
```

期待すること:

- tmux workspace が起動する
- context pane が開く
- repo-local `.ai-dev-os/` 設定が使われる

## 6. Inspect A Review Flow

```bash
ai review --help
```

## 7. Run Prompt Evaluation

Stage 3: local path が見えたあとに optional な prompt check を足す。

```bash
ai eval review
```

## 8. Explore The Fixture

- `.ai-dev-os/agents.yml`
- `.ai-dev-os/workflows.yml`
- `.ai-dev-os/prompts/implementer.md`
- `.ai-dev-os/prompts/reviewer.md`
- `.ai-dev-os/prompts/review.prompt.yml`

## Notes

- この fixture は `ai init` が生成する starter の mirror として同期させる
- `demo/sample-project/README.md` は fixture 自体の top-level staged adoption entrypoint として保つ
- local-only / PR CI / hosted eval の adoption model も generated starter README と揃える
- starter workflow の `fallback_agents` や prompt asset の形もここで確認できる
- 困った時の最初の確認は `ai doctor`
- local onboarding failure は `ai doctor`、CI/runtime pinning failure は `docs/42-github-actions.md`、bootstrap failure は `make doctor`
- CI runtime pinning や hosted eval は local path が安定してから `docs/42-github-actions.md` を見る
- sync check は `test/demo_assets.sh` で行う
