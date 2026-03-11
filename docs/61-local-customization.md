# Local Customization

AI Dev OS host layer は「共通で持ちたい設定」と「端末固有の設定」を分ける前提。

共通設定は repo に入れ、端末固有のものは以下に逃がす。

## 1. `~/.config/ditfiles/local.zsh`

用途:

- proxy
- 社内 CA 関連の環境変数
- 端末固有の PATH
- `AI_DEV_OS_EDITOR`
- `AI_DEV_OS_FORCE_VIM`
- `ZSH_PROFILE=1`

例:

```zsh
export HTTP_PROXY=http://proxy.example:8080
export HTTPS_PROXY=http://proxy.example:8080
export NO_PROXY=localhost,127.0.0.1

export AI_DEV_OS_EDITOR="vim"
```

互換性のため、既存の `DITFILES_EDITOR` / `DITFILES_FORCE_VIM` も引き続き使える。

注意:

- shell script として `source` される
- 単なるデータ置き場ではなく、**実行されるコード**

## 2. `~/.config/ditfiles/local.tmux.conf`

用途:

- 端末や会社 PC 固有の tmux override
- mouse の再設定
- terminal capability の微調整
- 一時的な keybind override

例:

```tmux
set -g mouse off
```

## 3. `ansible/local.yml`

用途:

- `git_name`
- `git_email`
- keyboard の値上書き
- Dock app 一覧の上書き

作り方:

```bash
cp ansible/local.yml.example ansible/local.yml
```

例:

```yaml
git_name: "Your Name"
git_email: "you@example.com"
keyboard_keyrepeat: 2
keyboard_initial_keyrepeat: 15
```

## 4. Git の個人設定

用途:

- credential helper
- signing key
- 会社固有の `includeIf`
- repo 共通化したくない alias / behavior

置き方:

- `~/.gitconfig` に直接書く
- もしくは user-owned な include file を `~/.gitconfig` から読む

注意:

- `~/.config/ditfiles/gitconfig` や `~/.config/ditfiles/conf.d` は repo-managed
- token / credential / signing key path は repo-managed file に置かない

## どこに何を書くべきか

- shell の環境変数や editor: `local.zsh`
- tmux の挙動: `local.tmux.conf`
- Ansible の変数: `ansible/local.yml`
- git の credential / signing / 個人 override: `~/.gitconfig` 側
- token / 秘密鍵 / credential: repo に入れない。`docs/50-secrets.md`
