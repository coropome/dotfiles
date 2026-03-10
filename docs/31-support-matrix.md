# Support Matrix

## 公式サポート

- OS: **macOS**
- パッケージ管理: **Homebrew**
- shell: **zsh**
- multiplexer: **tmux**

## best-effort / 将来対応の余地

- Linux
- WSL

ただし現状は以下の理由で bootstrap 対象外。

- `install.sh` と `ansible/run.sh` が Darwin 前提
- package install が Homebrew 前提
- macOS defaults / Dock / `UseKeychain` などの設定を含む

## 実質的な前提ツール

- Homebrew
- Xcode Command Line Tools
- bash
- zsh
- git
- tmux

## Linux / WSL で今使えるもの

- `zsh/zshrc` の一部
- `tmux/tmux.conf` の一部
- helper command の一部
- compatibility helper
  - `~/.local/bin/_clipboard_copy`
  - `~/.local/bin/_open`
  - `~/.local/bin/_tmux_help`

ただし「一部動く」と「bootstrap がサポートされる」は別。
Linux / WSL では、現状は **自己責任の手動適用** 扱い。

`make doctor` は Linux / WSL でも使えるが、出力は best-effort health check。
不足項目の remediation は `make install` / `make mac` ではなく、manual setup を案内する。

### current wrapper behavior

- Linux package manager detection
  - `apt-get`
  - `dnf`
  - `pacman`
  - `apk`
- Linux open wrapper
  - `xdg-open`
- Linux clipboard wrapper
  - `wl-copy`
  - `xclip`
  - `xsel`
- WSL open wrapper
  - `wslview`
  - `explorer.exe`
  - `xdg-open`
- WSL clipboard wrapper
  - `clip.exe`

どれも見つからない場合は raw failure ではなく remediation message を返す。

## ドキュメントの読み方

- macOS で導入する: `docs/02-bootstrap-flow.md`
- 会社端末や proxy がある: `docs/60-corporate.md`
- ローカル override を入れる: `docs/61-local-customization.md`
