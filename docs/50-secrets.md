# 別管理（Secrets / 端末固有）チェックリスト

目的：dotfiles（ditfiles）に入れないものを明確にして、事故（漏洩・上書き・移植失敗）を防ぐ。

## 絶対に repo に入れない（秘密情報）

- `~/.ssh/`（秘密鍵、known_hosts）
- `~/.aws/`（特に `credentials`）
- `~/.config/gcloud/`
- `~/.config/gh/hosts.yml`（GitHubトークン）
- `~/.netrc`
- `~/.npmrc`（tokenが入る場合あり）
- `~/.pypirc`
- `~/.docker/config.json`
- `~/.kube/config`
- `~/.terraform.d/credentials.tfrc.json`
- `.env` / `.env.*`（プロジェクトの秘密）

### 管理先（おすすめ）

- 1Password / Bitwarden / Apple Keychain などのパスワードマネージャ
- どうしてもファイルで持つなら：暗号化バックアップ（age/gpg）

## 移植すると壊れやすい（端末固有）

- `~/Library/Preferences/`（macOSの設定全般）
- `~/Library/Application Support/`（アプリ状態）
- `~/.local/share/`（アプリ状態/キャッシュ）
- `~/.config/karabiner/`（キーマップ）

## 逆に ditfiles に入れて良いもの（安全）

- `~/.zshrc`（ただし秘密を直書きしない）
- `~/.config/tmux/tmux.conf`
- git の一般設定（`user.email` などは好み。tokenは入れない）
- エイリアス、関数、プロンプト

## 実運用メモ

- 「まず動く環境」を ditfiles で作る
- 秘密は“別管理”で後から流し込む
- 既存Macの移行は、`make mac`（アプリ導入）→ 必要に応じて秘密を復元、の順が安全
- git credential helper は OS keychain 系を使い、`credential.helper store` は避ける
- signing key は GitHub 認証鍵と分ける方が安全
