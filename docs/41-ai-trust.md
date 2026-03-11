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

## Commands

```bash
ai trust init claude --project
ai trust init codex --user
ai trust apply gemini --project
ai trust apply all --user
```

`ai trust init` は target file がなければ生成し、既存 file がある時は skip して next command を返す。
`ai trust apply` は既存 file がある時に backup を作ってから template を適用する。
どちらも silent overwrite はしない。

## How To Use

1. まず `ai trust init <vendor> --project` で repo-local trust config を作る
2. user-level config を揃えたい時だけ `ai trust apply <vendor> --user` を使う
3. 生成元 template を確認したい時は `ai-agent --describe <vendor>` かこの doc の template 一覧を見る
4. AI Dev OS 側では `.ai-dev-os/agents.yml` や `.ai-dev-os/workflows.yml` で role routing だけ変える

## Scopes

- `--project`
  - Claude: `.claude/settings.json`
  - Codex: `.codex/config.toml`
  - Gemini: `.gemini/settings.json`
- `--user`
  - Claude: `~/.claude/settings.json`
  - Codex: `~/.codex/config.toml`
  - Gemini: `~/.gemini/settings.json`

project scope を先に使うと repo 単位で安全に trial しやすい。
user scope は複数 repo で共通化したい時に使う。

## Project Overrides

- Claude は `.claude/settings.json` を repo に置ける時はそちらを優先する
- Codex は `.codex/config.toml`、Gemini は `.gemini/settings.json` を repo に置いて project-local trust config を分けられる
- workflow routing は `.ai-dev-os/agents.yml` / `.ai-dev-os/workflows.yml` で repo 単位に切り替える
- global config を直接書き換えず、まず template を repo-local override に寄せる
