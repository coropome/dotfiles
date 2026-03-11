# AI Dev OS

初心者にはわかりやすく、手慣れた人には深く速く使え、1年後も日常的に使い続けられることを目指す macOS-first の AI workspace platform。
AI workflow と starter repo onboarding を主役にしつつ、shell / tmux / git / bootstrap は OS レベルの host substrate として同じ runtime repo に同梱している。

- beginner 向けの入口は **`ai start`**
- tmux を直接使う場合の入口は **`tnew`**

設計思想: `docs/90-philosophy.md`
管理境界: `docs/91-state-ownership.md`
開発ルール: `docs/92-development-workflow.md`
agent instruction: `AGENTS.md`

---

## OSS Quickstart

```bash
git clone https://github.com/coropome/dotfiles.git
cd dotfiles

# bootstrap
./install
make agent
ai doctor

# workspace
ai start
```

これが beginner path。最初は AI Dev OS のこの flow だけでよい。

current newcomer MVP は、`./install` と `make agent` のあとに既存 repo で `ai init -> ai doctor -> ai workflows -> ai start` まで自走できること。

前提:

- 現在の bootstrap 対象は **macOS**
- `make install` の前に **Homebrew** が必要
- 実運用上は **Xcode Command Line Tools** も必要
- Linux / WSL では `make install` / `make mac` はサポート外。runtime 設定の参照先として docs を使う
  - `ai-open` / `ai-copy` が late failure する時は `docs/31-support-matrix.md` と `docs/99-troubleshooting.md` を見る

次に読む:

- 最短の導入ガイド: `docs/00-quickstart.md`
- 10分 demo: `docs/05-demo-walkthrough.md`
- フェーズ説明: `docs/02-bootstrap-flow.md`
- サポート範囲: `docs/31-support-matrix.md`

## Paths

- Beginner path
  - `./install`
  - `make agent`
  - `ai start`
  - 別 repo では `ai init -> ai doctor -> ai workflows -> ai start`
- Advanced / manual path
  - `make install`
  - `make mac`
  - `make agent`
  - `tnew`, `tmux`, local overrides, manual vendor config
  - AI Dev OS の入口を使いつつ、必要な層までそのまま降りて調整できる

この二つは別製品ではなく同じ基盤の二つの見え方で、beginner path を壊さずに advanced path を深く保つ。

## If Agent CLI Is Missing

- `ai start` の前に `make agent` を実行する
- trust config の starter は `ai trust init claude --project`
- `ai doctor` で workflow / prompt / trust / fallback / runtime config 側を確認する
- `make doctor` で host bootstrap / symlink / PATH / shell / system state 側を確認する
- 詳細な分岐は `docs/99-troubleshooting.md`

`ai code` / `ai review` / `ai improve` は agent metadata に定義した `prompt_file` と repo context を vendor CLI に handoff する。
workflow chain をざっと見たい時は `ai --help` か `ai workflows` を使う。
どちらも default agent に加えて fallback chain の確認入口になる。
必要なら `ai-agent --describe --workflow review` で launch behavior と参照 config を確認する。
workflow に `fallback_agents` を comma-separated で定義しておくと、primary agent が unavailable の時に次の候補へ切り替える。
trust template も terminal から `ai trust init` / `ai trust apply` で生成・適用できる。詳細は `docs/41-ai-trust.md`。

### 別の repo で AI Dev OS を使う

この shared AI Dev OS runtime repo を入れたあと、作業したい repo では次だけで始められる。

```bash
cd /path/to/your-repo
ai init
ai doctor
ai workflows
ai start
```

`ai init` は `.ai-dev-os/` を project-local に生成し、既存ファイルは上書きしない。
default では GitHub Actions starter も生成する。不要なら `--no-github-actions`、hosted eval だけ外したいなら `--no-hosted-eval` を使う。
starter workflow には `fallback_agents` も入れられるので、primary agent が unavailable の時の退避先も repo-local に持てる。
starter を触ったあとに困ったら、まず `ai doctor` で workflow 解決と missing config を確認する。
generated README の next step もこの MVP path に沿って、実行可能な command だけを出す。
trust guidance は machine-specific path を埋め込まず、`ai trust init` / `ai trust apply` ベースで案内する。

GitHub Actions starter も必要なら一緒に生成できる。

- `.github/workflows/ai-dev-os-pr.yml`
- `.github/workflows/ai-dev-os-hosted-eval.yml`

local path が安定してから、必要なら PR smoke 用の `ai-dev-os-pr.yml`、さらに必要なら manual dispatch の `ai-dev-os-hosted-eval.yml` を足す。
runtime source は `AI_DEV_OS_RUNTIME_REPOSITORY` と `AI_DEV_OS_RUNTIME_REF` で切り分けられるが、fork / branch / tag pinning は必要になった時だけ触ればよい。
`--no-github-actions` の時は local path を優先し、`--no-hosted-eval` の時は PR workflow までで止める。
選び分けと troubleshooting は `docs/42-github-actions.md` に寄せている。

### Host Bootstrap の挙動（重要）

- `make install` は Homebrew で core パッケージを入れたうえで、`.zshrc` / `.zprofile` / tmux / git / helper commands を **シンボリックリンクで差し替え**ます
- `~/.gitconfig` に `include.path` を追加します
- tmux plugin manager と persistence plugin を `~/.tmux/plugins` に配置します
- 既存ファイルがある場合は自動バックアップします：`*.bak.YYYYMMDD-HHMMSS`
  - 例：`~/.zshrc.bak.20260309-165200`

---

## まず覚える（これだけ）

- `ai start`：AI Dev OS の workspace を起動
- `ai doctor`：starter repo で最初に困り方を切り分ける
- `ai code` / `ai review`：AI workflow の入口
- `tnew`：tmux を直接扱いたい時の入口

`ai start` が最短の入口で、`ai doctor` が最初の診断入口。`tnew` は tmux を直接使いたい人向けの低レベル入口として残している。

prefix は **Ctrl-a**（互換: **Ctrl-b** もOK）

- `prefix + |` / `prefix + -`：pane 分割
- `prefix + d`：detach
- `prefix + ?` / `prefix + /`：help
- `prefix + [`：copy-mode

詳細:

- tmux の基本: `docs/10-tmux.md`
- copy-mode と clipboard: `docs/11-copy-mode.md`
- 5〜10分で慣れる: `ttutor` / `docs/01-tutorial.md`

---

## 便利コマンド（小ネタ）

- `ccat <file>`：`bat` が入っている場合の、色付きビューア（`cat` は上書きしない）

---

## Mac セットアップ（Ansible）

- `make mac`：アプリ / CLI 導入
- `make defaults` / `make keyboard` / `make dock` / `make ssh`：OS や端末の状態変更
- 詳細: `docs/30-mac-setup.md`

---

## ローカル上書き（会社/端末固有）

端末固有・会社固有の設定は repo ではなく local override に逃がす前提です。

- 全体像: `docs/61-local-customization.md`
- 会社端末向け: `docs/60-corporate.md`
- secrets: `docs/50-secrets.md`

---

## Secrets（別管理）

`.ssh` / `.aws` / 各種tokenなど、秘密情報は **この runtime repo に入れない**。
チェックリスト：`docs/50-secrets.md`

---

## もとに戻す（git include）

この repo の host git layer は `~/.gitconfig` に include を追加します。
不要なら：

```bash
make uninstall
```

`make uninstall` が戻すのは主に symlink / git include / 直近バックアップ。
Homebrew packages、`~/.tmux/plugins`、agent CLI、`~/.ssh`、macOS defaults は戻しません。

詳細: `docs/02-bootstrap-flow.md`

---



## git の挙動メモ（pull は merge）

host git layer の `gitconfig` は `git pull` のデフォルト挙動を **merge（標準）** のままにしている。

- その場だけ rebase したい時：

```bash
git pull --rebase
```

git layer の構成と include の仕組み、optional signing の考え方は `docs/03-git.md` を参照。

---

## よく使う make ターゲット

- まずは `make help`
- `make install`：core setup
- `make mac`：アプリ / CLI 導入
- `make agent`：AI agent CLI セットアップ
- `make doctor`：状態確認
- `make test`：回帰確認
- `make uninstall`：symlink と git include を戻す
- 詳細な target 一覧: `make help`
- macOS 系 target の説明: `docs/30-mac-setup.md`
- support boundary と manual apply: `docs/31-support-matrix.md`



## Docs

導入:

- `docs/00-quickstart.md`
- `docs/02-bootstrap-flow.md`
- `docs/31-support-matrix.md`

tmux / daily workflow:

- `docs/01-tutorial.md`
- `docs/10-tmux.md`
- `docs/11-copy-mode.md`
- `docs/12-mouse.md`

macOS setup:

- `docs/20-iterm2.md`
- `docs/30-mac-setup.md`

git / CLI:

- `docs/03-git.md`
- `docs/40-cli.md`
- `docs/42-github-actions.md`
- `docs/41-ai-trust.md`

local customization / secrets:

- `docs/50-secrets.md`
- `docs/60-corporate.md`
- `docs/61-local-customization.md`

repo policy / maintenance:

- `docs/90-philosophy.md`
- `docs/91-state-ownership.md`
- `docs/92-development-workflow.md`
- `docs/99-troubleshooting.md`

---
