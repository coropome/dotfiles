# Bootstrap Flow

AI Dev OS runtime repo に含まれる host bootstrap layer を、「何が変わるか」を含めて短く整理したガイド。

## 前提

- 現在のサポート対象は **macOS**。Linux / WSL 向けの設定片は一部あるが、bootstrap は macOS 前提
- `make install` / `make mac` の前に **Homebrew** が必要
- 実運用上は **Xcode Command Line Tools** も必要
- 既存の host config がある場合、この repo は上書き前に `*.bak.YYYYMMDD-HHMMSS` を作る
- Linux / WSL ではこのドキュメントは runtime reference 扱いで、bootstrap 手順そのものはサポート外

## フェーズ

### 1. `make install`

目的：**core setup**

- `manifests/packages/core-brew.txt` 由来の `Brewfile` を `brew bundle` で導入
- 以下を symlink で有効化
  - `~/.zprofile`
  - `~/.zshrc`
  - `~/.config/tmux/tmux.conf`
  - `~/.config/ditfiles/gitconfig`
  - `~/.config/ditfiles/conf.d`
  - `~/.config/ditfiles/gitignore_global`
  - `~/.config/starship.toml`
  - `~/.local/bin/*`
- `~/.gitconfig` に `include.path` を追加
- tmux plugin manager と persistence plugin を `~/.tmux/plugins` に配置

### 2. `make mac`

目的：**apps / CLI / runtimes**

- `manifests/packages/macos-brew.txt` / `manifests/packages/macos-cask.txt` 由来の package vars を Ansible 経由で導入
- `node` / `uv` / `python3` / `gh` / `bat` / `eza` などもここに含む
- Finder / Dock / keyboard のような挙動変更はここでは行わない

### 3. `make agent`

目的：**agent CLI**

- Claude Code / Gemini / Codex CLI を Homebrew formula / cask で導入
- 初回ログインや API key 設定は手動

### 4. `make defaults`

目的：**macOS defaults**

- Finder / Dock / screenshot などの OS 設定を適用

### 5. `make keyboard`

目的：**入力系の挙動変更**

- キーリピート
- Caps Lock -> Control

### 6. `make dock`

目的：**Dock の managed layout**

- 現在の Dock 内容を消して並べ直す
- destructive なので確認あり

### 7. `make ssh`

目的：**GitHub 用 SSH セットアップ**

- `~/.ssh` 作成
- `id_ed25519` 生成
- `~/.ssh/config` に GitHub block を追加

## どの順番でやるか

最低限:

```bash
make install
```

一般的な新規 Mac:

```bash
make install
make mac
make agent
ai start
```

挙動変更も入れるなら:

```bash
make defaults
make keyboard
```

## 何が rollback されるか

`make uninstall` が戻すのは主に以下。

- この repo が作った symlink
- `~/.gitconfig` の `include.path`
- 直近バックアップの復元

戻さないもの:

- Homebrew packages / casks
- `~/.tmux/plugins`
- agent CLI の Homebrew install
- `~/.ssh` や生成済み鍵
- macOS defaults の変更

## 確認コマンド

```bash
make doctor
make test
ansible-playbook --syntax-check -i ansible/inventory/localhost.ini ansible/macos.yml
```
