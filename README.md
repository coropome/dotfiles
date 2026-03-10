# AI Dev OS / ditfiles

macOS-first の AI development environment。dotfiles と tmux を内部基盤として使いながら、beginner には `ai start` を入口として見せる。

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

# workspace
ai start
```

これが beginner path。最初はこの flow だけでよい。

前提:

- 現在の bootstrap 対象は **macOS**
- `make install` の前に **Homebrew** が必要
- 実運用上は **Xcode Command Line Tools** も必要
- Linux / WSL では `make install` / `make mac` はサポート外。runtime 設定の参照先として docs を使う

次に読む:

- 最短の導入ガイド: `docs/00-quickstart.md`
- フェーズ説明: `docs/02-bootstrap-flow.md`
- サポート範囲: `docs/31-support-matrix.md`

## Paths

- Beginner path
  - `./install`
  - `make agent`
  - `ai start`
- Advanced / manual path
  - `make install`
  - `make mac`
  - `make agent`
  - `tnew`, `tmux`, local overrides, manual vendor config

## If Agent CLI Is Missing

- `ai start` の前に `make agent` を実行する
- `make doctor` で `claude` / `gemini` / `codex` の検出状態を見る
- 詳細な分岐は `docs/99-troubleshooting.md`

### install の挙動（重要）

- `make install` は Homebrew で core パッケージを入れたうえで、`.zshrc` / `.zprofile` / tmux / git / helper commands を **シンボリックリンクで差し替え**ます
- `~/.gitconfig` に `include.path` を追加します
- tmux plugin manager と persistence plugin を `~/.tmux/plugins` に配置します
- 既存ファイルがある場合は自動バックアップします：`*.bak.YYYYMMDD-HHMMSS`
  - 例：`~/.zshrc.bak.20260309-165200`

---

## まず覚える（これだけ）

- `ai start`：AI Dev OS の workspace を起動
- `ai code` / `ai review` / `ai agents`：AI workflow の入口
- `tnew`：tmux を直接扱いたい時の入口

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

`.ssh` / `.aws` / 各種tokenなど、秘密情報は **ditfilesに入れない**。
チェックリスト：`docs/50-secrets.md`

---

## もとに戻す（git include）

ditfiles は `~/.gitconfig` に include を追加します。
不要なら：

```bash
make uninstall
```

`make uninstall` が戻すのは主に symlink / git include / 直近バックアップ。
Homebrew packages、`~/.tmux/plugins`、agent CLI、`~/.ssh`、macOS defaults は戻しません。

詳細: `docs/02-bootstrap-flow.md`

---



## git の挙動メモ（pull は merge）

ditfiles の `gitconfig` は `git pull` のデフォルト挙動を **merge（標準）** のままにしている。

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
