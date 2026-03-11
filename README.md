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

これが beginner path。最初はこの flow だけでよい。

current newcomer MVP は、`./install` と `make agent` のあとに既存 repo で `ai init -> ai doctor -> ai workflows -> ai start` まで自走できること。

前提はシンプルでよい。

- 現在の bootstrap 対象は **macOS**
- **Homebrew** と **Xcode Command Line Tools** が必要
- Linux / WSL は docs 参照ベースの support boundary

最短の導入ガイドは `docs/00-quickstart.md`、10分 demo は `docs/05-demo-walkthrough.md`、bootstrap の詳細は `docs/02-bootstrap-flow.md`、サポート範囲は `docs/31-support-matrix.md`。

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
  - `tnew`, `tmux`, local overrides, vendor-native config
  - AI Dev OS の入口を使いつつ、必要な層までそのまま降りて調整できる

この二つは別製品ではなく同じ基盤の二つの見え方で、beginner path を壊さずに advanced path を深く保つ。

## 別の repo で AI Dev OS を使う

この shared AI Dev OS runtime repo を入れたあと、作業したい repo では次だけで始められる。

```bash
cd /path/to/your-repo
ai init
ai doctor
ai workflows
ai start
```

`ai init` は `.ai-dev-os/` を project-local に生成し、既存ファイルは上書きしない。
starter を触ったあとに困ったら、まず `ai doctor` で workflow 解決と missing config を確認する。
GitHub Actions starter や runtime pinning は local path が安定してから足せばよい。詳細は `docs/40-cli.md` と `docs/42-github-actions.md`。

## 困った時

- `ai start` の前に `make agent` を実行する
- trust config の starter は `ai trust init claude --project`
- `ai doctor` で workflow / prompt / trust / fallback / runtime config 側を確認する
- `make doctor` で host bootstrap / symlink / PATH / shell / system state 側を確認する
- 詳細な分岐は `docs/99-troubleshooting.md`

---

## まず覚える（これだけ）

- `ai start`：AI Dev OS の workspace を起動
- `ai doctor`：starter repo で最初に困り方を切り分ける
- `ai code` / `ai review`：AI workflow の入口
- `tnew`：tmux を直接扱いたい時の入口

`ai start` が最短の入口で、`ai doctor` が最初の診断入口。`tnew` は tmux を直接使いたい人向けの低レベル入口として残している。

workflow chain をざっと見たい時は `ai --help` か `ai workflows` を使う。
必要なら `ai-agent --describe --workflow review` で launch behavior と参照 config を確認する。
trust template は `ai trust init` / `ai trust apply` から生成・適用する。詳細は `docs/40-cli.md` と `docs/41-ai-trust.md`。

## 深く使いたい時

- bootstrap 全体像と `make uninstall`: `docs/02-bootstrap-flow.md`
- tmux の基本と daily flow: `docs/01-tutorial.md`, `docs/10-tmux.md`, `docs/11-copy-mode.md`
- git layer と include: `docs/03-git.md`
- macOS setup: `docs/20-iterm2.md`, `docs/30-mac-setup.md`
- local override / corporate / secrets: `docs/61-local-customization.md`, `docs/60-corporate.md`, `docs/50-secrets.md`

README は top-level entrypoint に留め、host layer や operator 向けの細部は必要になったところで参照する前提にしている。

## Docs

- quickstart: `docs/00-quickstart.md`
- demo walkthrough: `docs/05-demo-walkthrough.md`
- CLI / workflow / trust: `docs/40-cli.md`, `docs/41-ai-trust.md`
- CI / hosted eval / runtime pinning: `docs/42-github-actions.md`
- troubleshooting: `docs/99-troubleshooting.md`
- philosophy / ownership / workflow rules: `docs/90-philosophy.md`, `docs/91-state-ownership.md`, `docs/92-development-workflow.md`

---
