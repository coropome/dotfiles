# CLIツール最小チートシート（AI Dev OS）

目的：AI Dev OS の newcomer path と、必要最小限の host/runtime helper を短くまとめる。

## agent CLI の位置づけ

`make mac` で `node` / `uv` / `python3` などの実行環境を揃え、`make agent` で以下の CLI を Homebrew 経由で入れる想定。

```bash
claude --version
gemini --version
codex --version
```

初回はそれぞれログインや API キー設定が必要なことがある。

## まず使うコマンド

AI Dev OS の入口は `ai --help` と `ai start`。starter repo で最初に困り方を切り分ける command は `ai doctor`。

```bash
ai --help
ai init
ai doctor
ai workflows
ai agents
ai-agent --describe --workflow review
ai start
```

`ai --help` は main commands に加えて、runtime repo path の `ai doctor -> ai start`、starter repo path の `ai init -> ai doctor -> ai workflows -> ai start`、その後ろに `deeper use` を表示する。
workflow に fallback chain がある場合は、`ai --help` がその discovery の入口になる。
repo に `.ai-dev-os/workflows.yml` や `.ai-dev-os/agents.yml` があれば、その override も discovery output に反映される。
unknown command に当たった時も、`ai` は `ai doctor` を先に、`ai workflows` を次に案内する。

## beginner surface と deeper surface

- beginner surface
  - `ai start`
  - `ai init`
  - `ai doctor`
  - まず workspace を開き、困り方を切り分けるところまでを担当する
- deeper surface
  - `ai workflows`
  - `ai agents`
  - `ai-agent --describe --workflow <name>`
  - fallback chain, prompt metadata, provider/runtime config の見え方を掘る時に使う

この分け方は「初心者には入口を明快にし、慣れた利用者には深く降りられるようにする」ためのもの。
一時的な wrapper ではなく、長く使う daily tool として surface を整理する。
trust 設定は beginner surface の常時コマンドというより、`ai doctor` が trust gap を示した時の remediation として使う。

`ai workflows` は `workflow | default agent | description` を基本に、必要なら fallback chain も含めて確認するための一覧。一覧を見たあとは、必要なら `ai-agent --describe --workflow <name>` で 1 つの workflow を深掘りし、その次に `ai start` へ進めば beginner path に戻りやすい。
`ai agents` は `agent | provider | role | command | description` を表示する。
`ai task` は pending backlog task の短い summary を先に出し、その後に full backlog を表示する。backlog refinement や次 sprint 候補の確認を始める時の入口として使う。
`ai start` の起動後は、まず `ai doctor` と `ai workflows` を見れば beginner path に戻りやすい。
`ai start` の workspace launch は today は tmux-backed session を使うが、その backend は current implementation であり AI Dev OS control plane そのものではない。
project-local scaffold を作りたい時は `ai init` を使う。
`ai doctor` は workflow resolution、missing binary、missing prompt/config、fallback path、vendor-native runtime path (`project_config`, `user_config`, `mcp_config`, `project_extensions`) を human-readable に返す。healthy path では `ai workflows -> ai start`、warn path では `ai workflows -> optional ai-agent --describe --workflow <name> -> ai start`、fail path では `fix the reported gaps above -> rerun ai doctor -> ai workflows` の next step を最後に返す。
`ai code` / `ai review` / `ai improve` は agent metadata にある `prompt_file` と `.context/summary.md` を使って vendor CLI に自然な形で handoff する。
launch 挙動は `ai-agent --describe <agent>` や `ai-agent --describe --workflow <name>` で確認できる。

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
- trust policy の starter 生成は `ai trust init` / `ai trust apply` から行う
- underlying template asset は `templates/ai-trust/` に置く

例:

```yaml
# .ai-dev-os/workflows.yml
workflows:
  review:
    default_agent: local_reviewer
    fallback_agents: local_backup_reviewer, local_researcher
```

```yaml
# .ai-dev-os/agents.yml
agents:
  local_reviewer:
    command: gemini
    role: reviewer
```

この形なら、AI Dev OS の shell code を編集せずに repo ごとの workflow を差し替えられる。
`fallback_agents` は comma-separated で書き、primary agent が unavailable の時に左から順に使う。

## 新しい role を足す

role を増やす時は `bin/` を編集しない。

1. `ai/agents.yml` か `.ai-dev-os/agents.yml` に agent を追加する
2. `command`, `role`, `prompt_file` を入れる
3. 必要なら `prompt_handoff`, `context_handoff`, `user_config`, `project_config`, `mcp_config` を足す
4. `ai/workflows.yml` か `.ai-dev-os/workflows.yml` で workflow からその role を参照し、必要なら `fallback_agents` を足す
5. `ai-agent --describe <role>` で metadata を確認する

例:

```yaml
agents:
  local_architect:
    command: claude
    role: architect
    prompt_file: prompts/architect.md
    prompt_handoff: append-system-prompt
    context_handoff: prompt
```

```yaml
workflows:
  plan:
    default_agent: local_architect
    fallback_agents: local_reviewer
```

trust policy template の場所も `ai-agent --describe <role>` で確認できる。
workflow 起点で確認したい時は `ai-agent --describe --workflow <name>` を使う。
`prompt_handoff` / `context_handoff` は今のところ `append-system-prompt`, `prompt`, `none` を受け付ける。
workflow fallback を含めた現在の解決状態を見たい時は `ai doctor` を使う。

## ai trust

vendor-native trust config を template から安全に生成・適用する入口は `ai trust`。

```bash
ai trust init claude --project
ai trust init codex --user
ai trust apply gemini --project
```

原則:

- `init` は file がない時だけ生成する
- `apply` は既存 file を backup してから上書きする
- overwrite は silent に行わない
- config format 自体は vendor native のままで、AI Dev OS 独自 format は増やさない

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
ai init --no-github-actions
ai init --no-hosted-eval
```

生成するもの:

- `.ai-dev-os/agents.yml`
- `.ai-dev-os/workflows.yml`
- `.ai-dev-os/prompts/implementer.md`
- `.ai-dev-os/prompts/reviewer.md`
- `.ai-dev-os/prompts/review.prompt.yml`
- `.ai-dev-os/README.md`

`ai init` は workflow routing と prompt artifact を生成するだけで、vendor-native config は直接上書きしない。
trust policy は `ai trust init` / `ai trust apply` から template を使って生成する。
starter workflow には `fallback_agents` も書けるので、repo ごとに workflow fallback を持てる。
starter を作った直後の最初の確認は `ai doctor`。
newcomer MVP の最短導線は `ai init -> ai doctor -> ai workflows -> ai start`。
generated README は local onboarding を先に出し、GitHub Actions は optional section に分ける。

default では GitHub Actions starter も生成する。
全部 skip したい時は `--no-github-actions`、hosted eval だけ外したい時は `--no-hosted-eval` を使う。

- `.github/workflows/ai-dev-os-pr.yml`
- `.github/workflows/ai-dev-os-hosted-eval.yml`

`ai-dev-os-pr.yml` は PR 用の prompt validation と CLI smoke test を回す。
`ai-dev-os-hosted-eval.yml` は manual dispatch 前提の opt-in hosted eval 用。
どちらも target repo に加えて AI Dev OS runtime repo を checkout する。
runtime source は `AI_DEV_OS_RUNTIME_REPOSITORY` と `AI_DEV_OS_RUNTIME_REF` で切り替えられ、fork / branch / tag に pin できる。
`--no-github-actions` の時は generated README / next step も local starter 前提になる。
`--no-hosted-eval` の時は PR workflow だけを出し、hosted eval は後から opt-in で足す前提になる。
詳細は `docs/42-github-actions.md`。

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

host git layer では pager を delta に寄せている（install 時に ~/.gitconfig に include を追加）。

```bash
delta --version
```

## zoxide: cdが速くなる

```bash
zoxide init zsh   # これは設定に入れる用（手で毎回打たない）

z <dir>           # 近いディレクトリへジャンプ（履歴から）
zi                # fzfがあれば対話的
```

host shell layer では zshrc で自動的に有効化する（zoxide が入っている場合）。

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

探索ルートは `AI_DEV_OS_PROJECT_ROOTS` で `:` 区切り指定できる。

```bash
export AI_DEV_OS_PROJECT_ROOTS="$HOME/work:$HOME/oss:$HOME/dotfiles"
export AI_DEV_OS_PROJECT_MAX_DEPTH=4
```

`DITFILES_PROJECT_ROOTS` / `DITFILES_PROJECT_MAX_DEPTH` と古い `P_ROOTS` も後方互換で受け付けるが、新規設定は `AI_DEV_OS_PROJECT_ROOTS` / `AI_DEV_OS_PROJECT_MAX_DEPTH` を使う。

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

※ host layer は `cat` を上書きしない（事故防止）。
