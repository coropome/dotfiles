# 会社端末（情シス）向けメモ

AI Dev OS host layer は個人環境の生産性を上げるが、会社端末で使う場合は以下を確認する。

## Homebrew の扱い

- 会社ポリシーで Homebrew が許可/禁止されることがある
- 監査・脆弱性管理・ライセンス（特に有償アプリ）に注意

## プロキシ環境

必要なら `~/.config/ditfiles/local.zsh` に以下を置く（repoには入れない）：

```zsh
export HTTP_PROXY=http://proxy.example:8080
export HTTPS_PROXY=http://proxy.example:8080
export NO_PROXY=localhost,127.0.0.1
```

Homebrew 用に `HOMEBREW_*` が必要な場合もある。

local override 全体の置き場所は `docs/61-local-customization.md` を参照。

## 既存設定との衝突

- `make install` は Homebrew の core パッケージ導入に加えて `.zshrc` / `.zprofile` / tmux / git / helper commands を導入する（既存ファイルがあれば自動バックアップは作る）
- `~/.gitconfig` に `include.path` を追加する
- `~/.tmux/plugins` に plugin bootstrap を作る
- 会社指定の環境変数/証明書設定/EDR関連の初期化がある場合は `local.zsh` に逃がす

## 変更管理の考え方

- `make mac`（アプリ導入）と `make keyboard`（挙動変更）を分けている
- 会社端末はまず `make mac` のみ、必要時に `make keyboard` を検討
- Dock / SSH / defaults はさらに state change が大きいので、必要なものだけ選んで実行する
