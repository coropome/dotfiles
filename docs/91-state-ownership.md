# State Ownership

チームで保守する時に「どこが何を管理しているか」を先に固定するためのメモ。

この repo では AI Dev OS を primary surface とし、dotfiles / tmux / git include / bootstrap は host substrate として扱う。

## shell script が管理するもの

- symlink の作成 / 削除
- バックアップ作成 / 復元
- `~/.gitconfig` の `include.path`
- `~/.tmux/plugins` の bootstrap

対象:

- `install.sh`
- `uninstall.sh`
- `doctor.sh`

## AI Dev OS control plane が管理するもの

- `ai` CLI surface
- workflow routing
- agent metadata
- prompt handoff / context handoff
- starter repo scaffold
- trust policy template への導線
- workflow / trust / starter docs と tests

対象:

- `bin/ai`
- `bin/ai-agent`
- `bin/ai-init`
- `bin/ai-doctor`
- `bin/ai-trust`
- `ai/`
- `prompts/`
- `templates/ai-trust/`
- `templates/github-actions/`
- `docs/40-cli.md`
- `docs/41-ai-trust.md`
- `docs/42-github-actions.md`

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

## host configuration layer が管理するもの

- zsh 設定
- tmux 設定
- git の一般設定
- helper command
- host bootstrap docs / tests

## plugin manager / 外部ツールに依存するもの

- tmux plugin の実行時挙動
- Homebrew install される agent CLI
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
