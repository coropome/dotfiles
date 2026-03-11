# トラブルシューティング

症状から確認コマンドへすぐ入るためのメモ。
通常の手順や仕様説明は各 owner doc を参照する。

- bootstrap / rollback: `docs/02-bootstrap-flow.md`
- tmux / copy-mode: `docs/10-tmux.md`, `docs/11-copy-mode.md`
- AI CLI / workflow / trust: `docs/40-cli.md`, `docs/41-ai-trust.md`
- macOS setup: `docs/30-mac-setup.md`
- support boundary: `docs/31-support-matrix.md`

## まずどちらを使うか

- `ai doctor`
  - AI Dev OS の workflow / prompt / trust / fallback / runtime config を診断する
  - starter repo で `ai init` 後に困った時の first response
- `make doctor`
  - dotfiles install / symlink / PATH / shell / bootstrap / system state を見る
  - `./install` や `make agent` の前後で system 側の異常を疑う時に使う

迷ったら:

1. starter repo の `ai code` / `ai review` / `ai start` で詰まったら `ai doctor`
2. `tmux` や `~/.local/bin` や symlink や install 自体が怪しければ `make doctor`

## AI Dev OS Starter Repos

- `ai init` した repo で最初に何を見るか分からない
  - `ai doctor`
  - `ai workflows`
  - `ai-agent --describe --workflow review`
- `ai doctor` が missing binary を出す
  - `make agent`
  - `claude --version`
  - `gemini --version`
  - `codex --version`
  - install 後も足りなければ `docs/40-cli.md`
- `ai doctor` が missing prompt file / missing config を出す
  - `.ai-dev-os/agents.yml`
  - `.ai-dev-os/workflows.yml`
  - `.ai-dev-os/prompts/`
  - `ai init` を rerun して skip / generated の差分を見る
- `ai doctor` が trust config 不足を出す
  - `ai trust init claude --project`
  - `ai trust init codex --project`
  - `ai trust init gemini --project`
  - user scope を触る時だけ `ai trust apply <vendor> --user`
- `ai workflows` / `ai --help` に expected workflow が出ない
  - `.ai-dev-os/workflows.yml`
  - `.ai-dev-os/agents.yml`
  - `ai workflows`
  - `ai-agent --describe --workflow review`
- primary agent ではなく fallback が選ばれた
  - `ai workflows`
  - `ai-agent --describe --workflow review`
  - `ai doctor`
  - `fallback_agents` と install 済み CLI を見直す
- `no available agent candidates` が出る
  - `ai doctor`
  - missing backend CLI を入れるか、`.ai-dev-os/workflows.yml` の `default_agent` / `fallback_agents` を直す
  - `.ai-dev-os/agents.yml` の `command` / `prompt_file` / `prompt_handoff` を確認する
- `ai eval --hosted` だけ失敗する
  - `gh --version`
  - `ai eval review`
  - hosted eval が不要なら local path の `ai doctor` / `ai workflows` / `ai start` を先に進める
  - CI / hosted backend は `docs/42-github-actions.md`
- generated GitHub Actions だけ失敗して local path では再現しない
  - `AI_DEV_OS_RUNTIME_REPOSITORY`
  - `AI_DEV_OS_RUNTIME_REF`
  - `docs/42-github-actions.md`
  - fork / branch / tag pinning と local onboarding failure を分けて考える

## install / uninstall

- `make install` で Homebrew が失敗する
  - `brew doctor`
  - `brew update`
  - 直らなければ `brew bundle --file ./Brewfile`
- `ai start` の前に agent CLI が見つからない
  - `make agent`
  - `make doctor`
  - `claude --version`
  - `gemini --version`
  - `codex --version`
- Linux / WSL で `make install` / `make mac` を実行した
  - `docs/31-support-matrix.md`
- symlink が想定どおり張られない
  - `make doctor`
  - `make uninstall && make install`
- `make uninstall` 後に設定が戻らない
  - `ls -1 ~/.zshrc.bak.* ~/.zprofile.bak.* 2>/dev/null`
  - rollback の対象範囲は `docs/02-bootstrap-flow.md`

## zsh

- `tnew` や `p` が見つからない
  - `echo $PATH | tr ':' '\n' | grep "$HOME/.local/bin"`
  - 新しいシェルを開き直す
- zsh の起動が遅い
  - `ZSH_PROFILE=1 zsh -i -c exit`
  - `make doctor` で plugin / PATH の状態も確認する
- Linux / WSL で `make doctor` の NG が多い
  - `docs/31-support-matrix.md`
- `zsh-autosuggestions` や `zsh-syntax-highlighting` が効かない
  - `make doctor`
  - `brew --prefix`
- `fzf` はあるのに補完や keybind が効かない
  - `fzf --zsh`
  - Linux では `/usr/share/fzf/` 配下の script が入っているか確認する

## tmux

- tmux が起動しない
  - `tmux -V`
  - `tmux -f ~/.config/tmux/tmux.conf start-server`
- `prefix + ?` が popup ではなく split になる
  - `tmux -V`
  - help 挙動の違いは `docs/10-tmux.md`
- コピーがクリップボードへ入らない
  - `make doctor`
  - `~/.local/bin/_clipboard_copy <<< test`
  - Linux / WSL では `wl-copy` / `xclip` / `xsel` / `clip.exe` のどれが使えるか確認する
- Linux / WSL で `ai-open` が late failure する
  - `make doctor`
  - `~/.local/bin/_open https://example.com`
  - Linux は `xdg-open`、WSL は `wslview` / `explorer.exe` の有無を見る
- 色が変
  - `echo $TERM`
  - `tmux info | grep -E 'RGB|Tc'`

## git

- delta の色が出ない
  - `command -v delta`
  - `git config --global --get-all include.path`
  - `git config --global --includes --get core.pager`
- ditfiles の gitconfig が効かない
  - `git config --global --get-all include.path`
  - `git config --global --show-origin --get-all include.path`
  - `git config --global --includes --get core.excludesfile`
  - `make doctor`
- commit signing を有効にしたのに署名できない
  - `git config --global --get commit.gpgsign`
  - `git config --global --get gpg.format`
  - `git config --global --get user.signingkey`
  - `make doctor`

## Ansible

- `make mac` / `make dock` が失敗する
  - `brew doctor`
  - `ansible-playbook --syntax-check -i ansible/inventory/localhost.ini ansible/macos.yml`
  - target の意味は `docs/30-mac-setup.md`
- cask install が失敗する
  - `brew install --cask <name>`
  - 競合アプリや権限ダイアログが止めていないか見る
