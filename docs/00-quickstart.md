# Quickstart

このページは beginner path を優先する。AI Dev OS はまずわかりやすく入り、そのあと必要なら深く使い込める前提で設計している。advanced path は後半に分ける。

前提:

- 現在の bootstrap 対象は **macOS**
- `make install` の前に **Homebrew** が必要
- 実運用上は **Xcode Command Line Tools** も必要

## Beginner Path

1. iTerm2 をインストール（任意：標準Terminalでも可）
2. `./install` を実行
   - bootstrap wrapper。内部では `install.sh` を呼ぶ
3. `make agent` を実行
4. 新しいターミナルで `ai start`
   - default backend は `tmux`
   - terminal choice を固定したくない時は `ai start --backend stdio`

ここでは tmux や shell の細部を覚えなくてもよい。まず workspace が開き、`ai doctor` で困り方を切り分けられる状態まで進める。

別の Git repo を AI Dev OS で使いたい時は:

1. その repo に移動
2. `ai init`
3. `ai doctor`
4. `ai workflows`
5. `ai start`

`ai init` は repo root に `.ai-dev-os/` を作り、既存ファイルがあれば skip する。
current newcomer MVP はここで `ai init -> ai doctor -> ai workflows -> ai start` まで進めること。
generated README もこの local path を先に出し、trust setup は absolute path ではなく `ai trust init` / `ai trust apply` で案内する。
default では GitHub Actions starter も生成する。全部 skip したい時は `ai init --no-github-actions`、hosted eval だけ外したい時は `ai init --no-hosted-eval` を使う。
starter workflow には `fallback_agents` も書けるので、primary agent の代替候補を repo-local に持てる。
GitHub Actions starter を使う場合は `.github/workflows/ai-dev-os-pr.yml` と `.github/workflows/ai-dev-os-hosted-eval.yml` も生成する。
local path が安定してから、必要なら `ai-dev-os-pr.yml`、さらに必要なら `ai-dev-os-hosted-eval.yml` を足す。
runtime pinning は最初から触らず、fork / branch / drift control が必要になった時だけ `docs/42-github-actions.md` を見る。
local-only / PR CI / hosted eval の選び分けも `docs/42-github-actions.md` に寄せている。
workflow を生成しなかった時の next step は `ai doctor` / `ai workflows` / `ai start` を優先し、CI は必要になってから足す。

tmux を直接扱いたい時だけ `tnew` を使う。`ai start` 自体は `tmux` default だが、lighter path として `stdio` backend も選べる。

agent CLI が足りない時:

- `ai doctor`
- `make agent`
- `make doctor`
- `docs/99-troubleshooting.md`
- trust config の starter は `ai trust init claude --project`

この時の使い分けは、workflow / prompt / trust / fallback / runtime config なら `ai doctor`、host bootstrap / symlink / PATH / shell / system state なら `make doctor`。

`ai code` / `ai review` / `ai improve` は起動時に repo context を更新し、workflow に紐づく prompt metadata を vendor CLI へ渡す。
launch 詳細を見たい時は `ai-agent --describe --workflow <name>` を使う。

## Optional Setup

- アプリ/CLI: `make mac`
- Finder / Dock / Screenshot defaults: `make defaults`
- keyboard tweaks: `make keyboard`

## Advanced Path

advanced user は必要に応じて以下へ分岐してよい。

- `make install`
- `make mac`
- `make agent`
- `tnew`
- local override
- vendor-native config (`.claude/`, `.ai-dev-os/`, `~/.codex/`, `~/.gemini/`)

ここでは AI Dev OS の入口を捨てる必要はなく、必要な層にそのまま降りていけばよい。`ai start` と `tnew`、project-local config と vendor-native config を併用できるのが前提。

追加で入れるもの:

- アプリ/CLI: `make mac`
- agent CLI: `make agent`
- Finder / Dock / Screenshot defaults: `make defaults`
- keyboard tweaks: `make keyboard`

覚えるキーは最初これだけ：

- prefix: Ctrl-a（互換: Ctrl-b もOK）
- 分割: `|` / `-`
- 移動: `←/↓/↑/→`
- 次のpane: `Tab`
- ヘルプ: `?`

## iTerm2（おすすめ設定）

- 複数行ペースト警告をON（事故防止）
- キーバインドは増やしすぎない（tmuxに寄せる）

## よくあるつまずき

- tmuxから「抜けたい」: `Ctrl-a d`（detach）
  - また戻る: `ai start` / `tgo` / `tnew`
- 再起動後に作業を戻したい: `tnew` で tmux を起動すると、保存済み session が自動復元される
  - 手動保存: `Ctrl-a Ctrl-s`
  - 手動復元: `Ctrl-a Ctrl-r`
  - これらは現状 `tmux-resurrect` のデフォルト keybind

## チュートリアル

- 5〜10分で慣れる: `ttutor`
- 10分 demo: `docs/05-demo-walkthrough.md`
- bootstrap の全体像: `docs/02-bootstrap-flow.md`
- サポート範囲: `docs/31-support-matrix.md`
