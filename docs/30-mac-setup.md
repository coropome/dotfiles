# Mac セットアップ（Ansible）

目的：Macのセットアップを「できる範囲で」自動化する。

## 方針

- `make install` は最小構成の導入
- Homebrew の core パッケージは `Brewfile` で導入し、`.zprofile` / zsh / tmux / git / helper commands を有効化する
- `make mac` は安全側（アプリ導入と、agent用ランタイムの準備まで）
- `make agent` で Claude Code / Gemini / Codex CLI を Homebrew で入れる
- `make defaults` / `make keyboard` / `make dock` / `make ssh` は挙動変更や状態変更を伴うので phase を分ける
- キーボード/OS設定は環境差が大きいので **オプション**（`make keyboard`）

## 入れるパッケージ

パッケージ inventory の authority は `manifests/packages/*`。

- core package manifest: `manifests/packages/core-brew.txt`
- macOS formula manifest: `manifests/packages/macos-brew.txt`
- macOS cask manifest: `manifests/packages/macos-cask.txt`

互換用の committed artifact:

- `make install` は `Brewfile` を使う
- `make mac` は `ansible/vars/packages.yml` 経由で package vars を読む

一覧はコード側を参照（ここに列挙すると乖離するため）。

## 実行

```bash
# dotfiles
make install

# apps/tools
make mac

# agent CLIs
make agent

# macOS defaults
make defaults

# optional: keyboard tweaks
make keyboard
```

補足:

- `make dock` は destructive なので確認あり
- `make ssh` は `~/.ssh` と GitHub 向け設定を作る
- rollback 範囲は `docs/02-bootstrap-flow.md` を参照

## できない/手動が残るもの

- プライバシー権限（Accessibility / Screen Recording 等）
- Apple ID / iCloud ログイン
- 一部アプリの初回セットアップ
- agent CLI のログイン認証

## 関連ドキュメント

- bootstrap の全体像: `docs/02-bootstrap-flow.md`
- サポート範囲: `docs/31-support-matrix.md`
- local override: `docs/61-local-customization.md`
- state ownership: `docs/91-state-ownership.md`
