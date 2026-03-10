# Git

ditfiles の git layer は `~/.gitconfig` を直接上書きせず、`include.path` で読み込ませる。

## 何を管理するか

- pager / diff viewer (`delta`)
- merge / pull / push の基本挙動
- よく使う alias
- global ignore file の参照

実体:

- entrypoint: `git/gitconfig`
- modules: `git/conf.d/*.gitconfig`
- ignore: `git/gitignore_global`

## 何を管理しないか

- credential helper
- token
- commit signing key
- 個人の `user.name` / `user.email` 以外の秘密情報

これらは repo 外で持つ。

## 個人設定はどこに置くか

ditfiles が管理するのは `~/.config/ditfiles/gitconfig` 以下の共通設定だけ。

個人設定は以下に置く。

- `~/.gitconfig` に直接追加する
- もしくは自分で管理する include file を `~/.gitconfig` から読む

置かないもの:

- credential helper の実設定
- access token
- signing key path
- 会社固有の `includeIf`

repo-managed な `~/.config/ditfiles/*` は共通設定の置き場であって、個人 override の置き場ではない。

## Credential Policy

推奨:

- macOS では OS keychain 系 helper を使う
- credential は repo-managed file に書かない
- remote URL に token を埋め込まない

非推奨:

- `git config --global credential.helper store`

helper 自体は各自の `~/.gitconfig` で設定する。

## include の仕組み

`make install` は以下を行う。

- `~/.config/ditfiles/gitconfig` を symlink
- `~/.config/ditfiles/conf.d` を symlink
- `~/.config/ditfiles/gitignore_global` を symlink
- `~/.gitconfig` に `include.path` を追加

`make uninstall` は ditfiles が追加した `include.path` を外し、直近バックアップを戻す。

## Optional: commit signing

ditfiles は commit signing を強制しない。
理由:

- マシンごとの差分が大きい
- SSH signing / GPG signing の選択がチームや個人で分かれる
- fresh install の初期障壁を上げたくない

必要なら各自で local override として設定する。

推奨:

- GitHub 認証用とは別の signing key を使う
- signing 用の鍵にも passphrase を付ける

例:

```bash
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519_signing.pub
```

## 確認コマンド

```bash
git config --global --get-all include.path
git config --global --show-origin --get-all include.path
git config --global --includes --get core.pager
git config --global --includes --get merge.conflictstyle
git config --global --includes --get-regexp '^alias\.'
git config --global --get credential.helper
git config --global --get commit.gpgsign
```
