# AI Trust Defaults

AI Dev OS は MCP や agent automation を有効にする時、まず「狭い権限」で始める。

## Default Policy

- filesystem scope は `project-only` から始める
- network access は deny ではなく `ask` から始める
- shell command は allowlist を先に作る
- `~/.ssh`, `~/.aws`, secrets を含むディレクトリは block する
- vendor が project-local config を持つ場合は repo 側の設定を優先する

## Templates

- Claude: [`templates/ai-trust/claude-settings.json`](../templates/ai-trust/claude-settings.json)
- Codex: [`templates/ai-trust/codex-config.toml`](../templates/ai-trust/codex-config.toml)
- Gemini: [`templates/ai-trust/gemini-settings.json`](../templates/ai-trust/gemini-settings.json)

## How To Use

1. 使う agent の template を確認する
2. vendor native config にコピーする
3. repo ごとの override が必要なら project-local config を作る
4. AI Dev OS 側では `.ai-dev-os/agents.yml` や `.ai-dev-os/workflows.yml` で role routing だけ変える

## Project Overrides

- Claude は `.claude/settings.json` を repo に置ける時はそちらを優先する
- workflow routing は `.ai-dev-os/agents.yml` / `.ai-dev-os/workflows.yml` で repo 単位に切り替える
- global config を直接書き換えず、まず template を repo-local override に寄せる
