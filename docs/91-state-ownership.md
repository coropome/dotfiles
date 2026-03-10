# State Ownership

チームで保守する時に「どこが何を管理しているか」を先に固定するためのメモ。

## shell script が管理するもの

- symlink の作成 / 削除
- バックアップ作成 / 復元
- `~/.gitconfig` の `include.path`
- `~/.tmux/plugins` の bootstrap

対象:

- `install.sh`
- `uninstall.sh`
- `doctor.sh`

## Ansible が管理するもの

- Homebrew formula / cask 導入
- macOS defaults
- keyboard 調整
- Dock layout
- SSH 初期セットアップ
- git user.name / user.email

対象:

- `ansible/run.sh`
- `ansible/macos.yml`

## dotfiles 本体が管理するもの

- zsh 設定
- tmux 設定
- git の一般設定
- helper command
- docs / tests

## plugin manager / 外部ツールに依存するもの

- tmux plugin の実行時挙動
- npm global install される agent CLI
- Homebrew package の実際の version

## out of scope

- `.ssh` の秘密鍵そのもの
- `.aws` / `.config/gcloud/` / `.env` などの credential
- git credential helper の実値
- git signing key と passphrase
- user-owned な git include file
- Apple ID / iCloud
- アプリ個別の初回ログイン
- Accessibility / Screen Recording などの権限付与

## 保守の原則

- package の source of truth を増やしすぎない
- repo に入れるのは「再現したい共通状態」
- 端末固有・会社固有・秘密情報は overlay に逃がす
- rollback できる範囲を docs で明示する
