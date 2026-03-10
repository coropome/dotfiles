# CLIツール最小チートシート（ditfiles）

目的：入れたはいいが使わない、を防ぐための「最小だけ」まとめ。

## agent CLI の位置づけ

`make mac` で `node` / `uv` / `python3` などの実行環境を揃え、`make agent` で以下の CLI を Homebrew 経由で入れる想定。

```bash
claude --version
gemini --version
codex --version
```

初回はそれぞれログインや API キー設定が必要なことがある。

## まず使うコマンド

AI Dev OS の入口は `ai --help` と `ai start`。

```bash
ai --help
ai init
ai workflows
ai agents
ai-agent --describe --workflow review
ai start
```

`ai --help` は main commands に加えて、現在の repo で有効な workflow alias を表示する。
repo に `.ai-dev-os/workflows.yml` や `.ai-dev-os/agents.yml` があれば、その override も discovery output に反映される。

`ai workflows` は `workflow | default agent | description` の形で表示する。
`ai agents` は `agent | provider | role | command | description` を表示する。
project-local scaffold を作りたい時は `ai init` を使う。

backend CLI が足りない時は raw な `command not found` ではなく、resolved workflow / agent / config path / remediation を返す。
まずは `make agent` を見る。

## AI Dev OS config と vendor config の境界

AI Dev OS は orchestration layer として使い、vendor がすでに持っている機能はなるべく vendor native config に寄せる。

- AI Dev OS に書くもの
  - `.ai-dev-os/workflows.yml`
  - `.ai-dev-os/agents.yml`
  - どの workflow がどの agent を呼ぶか
  - repo 単位でどの CLI を優先するか
- vendor config に書くもの
  - `.claude/settings.json`
  - `.claude/agents/`
  - `~/.codex/config.toml`
  - `~/.gemini/settings.json`
  - MCP, hooks, subagents, headless mode, vendor 固有の権限や runtime 設定

原則:

- workflow routing は AI Dev OS 側で持つ
- MCP / hooks / native agent features は vendor 側で持つ
- repo ごとの上書きは `.ai-dev-os/` を優先する
- trust policy の starter template は `templates/ai-trust/` を使う

例:

```yaml
# .ai-dev-os/workflows.yml
workflows:
  review:
    default_agent: local_reviewer
```

```yaml
# .ai-dev-os/agents.yml
agents:
  local_reviewer:
    command: gemini
    role: reviewer
```

この形なら、AI Dev OS の shell code を編集せずに repo ごとの workflow を差し替えられる。

## 新しい role を足す

role を増やす時は `bin/` を編集しない。

1. `ai/agents.yml` か `.ai-dev-os/agents.yml` に agent を追加する
2. `command`, `role`, `prompt_file` を入れる
3. 必要なら `user_config`, `project_config`, `mcp_config` を足す
4. `ai/workflows.yml` か `.ai-dev-os/workflows.yml` で workflow からその role を参照する
5. `ai-agent --describe <role>` で metadata を確認する

例:

```yaml
agents:
  local_architect:
    command: claude
    role: architect
    prompt_file: prompts/architect.md
```

```yaml
workflows:
  plan:
    default_agent: local_architect
```

trust policy template の場所も `ai-agent --describe <role>` で確認できる。
workflow 起点で確認したい時は `ai-agent --describe --workflow <name>` を使う。

## ai eval

prompt artifact を repo asset として扱う入口は `ai eval`。

```bash
ai eval --list
ai eval review
ai eval --hosted review
```

今の `ai eval` は local-first で、`.prompt.yml` の構造確認と test case / evaluator 数の確認を行う。
hosted eval が必要なら `ai eval --hosted <name>` を使う。
`gh` が使えない時は remediation を返す。

新しい prompt artifact を足す時は:

1. `prompts/<name>.prompt.yml` を作る
2. `name`, `description`, `messages`, `testData`, `evaluators` を入れる
3. `ai eval <name>` で local check を通す
4. 必要なら `ai eval --hosted <name>` で hosted eval に流す

## ai init

新しい repo で AI Dev OS の local override を始める時は `ai init` を使う。

```bash
ai init
ai init --repo /path/to/project
```

生成するもの:

- `.ai-dev-os/agents.yml`
- `.ai-dev-os/workflows.yml`
- `.ai-dev-os/prompts/implementer.md`
- `.ai-dev-os/prompts/review.prompt.yml`
- `.ai-dev-os/README.md`

`ai init` は workflow routing と prompt artifact を生成するだけで、vendor-native config は直接上書きしない。
trust policy は生成された `.ai-dev-os/README.md` から `templates/ai-trust/` を参照する。

## rg（ripgrep）: 最強の全文検索

```bash
rg "keyword"                # カレント以下を検索
rg -n "keyword" file.txt    # 行番号付き
rg "TODO|FIXME"             # 正規表現OK
rg --hidden "keyword"       # 隠しファイルも
```

## fd: findの代替（速い）

```bash
fd "name"                   # 名前で探す（正規表現）
fd -t f "\.md$"             # ファイルだけ
fd -t d "src"               # ディレクトリだけ
```

## jq: JSONを読む/抜く

```bash
cat data.json | jq .                          # 整形表示
cat data.json | jq '.items[] | .id'           # フィールド抽出
curl -s URL | jq -r '.name'                   # -rで生文字
```

## gh: GitHub操作（PR/CI確認が速い）

```bash
gh auth status

gh repo view --web

gh pr list
# PRの詳細
# gh pr view <番号> --comments

# 失敗したCIを見る
# gh run list --limit 5
# gh run view <run-id> --log-failed
```

## delta: git diffを読みやすく

ditfilesでは git の pager を delta に寄せている（install時に ~/.gitconfig に include を追加）。

```bash
delta --version
```

## zoxide: cdが速くなる

```bash
zoxide init zsh   # これは設定に入れる用（手で毎回打たない）

z <dir>           # 近いディレクトリへジャンプ（履歴から）
zi                # fzfがあれば対話的
```

ditfilesでは zshrc で自動的に有効化する（zoxideが入っている場合）。

## htop: プロセス監視

```bash
htop
```

## eza: 見やすいls（好み）

```bash
eza -la
```

## p: プロジェクトを選んで `tnew`

```bash
p
```

探索ルートは `DITFILES_PROJECT_ROOTS` で `:` 区切り指定できる。

```bash
export DITFILES_PROJECT_ROOTS="$HOME/work:$HOME/oss:$HOME/dotfiles"
export DITFILES_PROJECT_MAX_DEPTH=4
```

古い `P_ROOTS` も後方互換で受け付けるが、新規設定は `DITFILES_PROJECT_ROOTS` を使う。

## zsh 起動時間の計測

zsh の立ち上がりが遅いと感じたら、`zprof` を有効にして確認できる。

```bash
ZSH_PROFILE=1 zsh -i -c exit
```

関数ごとの実行時間が出るので、重い初期化処理を特定しやすい。


## bat: pretty cat（ccat）

```bash
ccat file.txt
```

※ ditfilesは `cat` を上書きしない（事故防止）。
