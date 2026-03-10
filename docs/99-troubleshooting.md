# トラブルシューティング

症状から確認コマンドへすぐ入るためのメモ。
通常の手順や仕様説明は各 owner doc を参照する。

- bootstrap / rollback: `docs/02-bootstrap-flow.md`
- tmux / copy-mode: `docs/10-tmux.md`, `docs/11-copy-mode.md`
- macOS setup: `docs/30-mac-setup.md`
- support boundary: `docs/31-support-matrix.md`

## install / uninstall

- `make install` で Homebrew が失敗する
  - `brew doctor`
  - `brew update`
  - 直らなければ `brew bundle --file ./Brewfile`
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
  - `~/.local/bin/_clipboard_copy <<< test`
  - Linux / WSL では `wl-copy` / `xclip` / `xsel` / `clip.exe` のどれが使えるか確認する
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
