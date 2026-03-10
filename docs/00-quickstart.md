# Quickstart

このページは beginner path を優先する。advanced path は後半に分ける。

前提:

- 現在の bootstrap 対象は **macOS**
- `make install` の前に **Homebrew** が必要
- 実運用上は **Xcode Command Line Tools** も必要

## Beginner Path

1. iTerm2 をインストール（任意：標準Terminalでも可）
2. `./install` を実行
   - bootstrap wrapper。内部では `install.sh` を呼ぶ
3. `make agent` を実行
4. 新しいターミナルで `ai start`

別の Git repo を AI Dev OS で使いたい時は:

1. その repo に移動
2. `ai init`
3. `ai workflows`
4. `ai start`

`ai init` は repo root に `.ai-dev-os/` を作り、既存ファイルがあれば skip する。

tmux を直接扱いたい時だけ `tnew` を使う。

agent CLI が足りない時:

- `make agent`
- `make doctor`
- `docs/99-troubleshooting.md`

## Optional Setup

- アプリ/CLI: `make mac`
- Finder / Dock / Screenshot defaults: `make defaults`
- keyboard tweaks: `make keyboard`

## Advanced Path

advanced user は必要に応じて以下へ分岐してよい。

- `make install`
- `make mac`
- `make agent`
- `tnew`
- local override
- vendor-native config (`.claude/`, `.ai-dev-os/`, `~/.codex/`, `~/.gemini/`)

追加で入れるもの:

- アプリ/CLI: `make mac`
- agent CLI: `make agent`
- Finder / Dock / Screenshot defaults: `make defaults`
- keyboard tweaks: `make keyboard`

覚えるキーは最初これだけ：

- prefix: Ctrl-a（互換: Ctrl-b もOK）
- 分割: `|` / `-`
- 移動: `←/↓/↑/→`
- 次のpane: `Tab`
- ヘルプ: `?`

## iTerm2（おすすめ設定）

- 複数行ペースト警告をON（事故防止）
- キーバインドは増やしすぎない（tmuxに寄せる）

## よくあるつまずき

- tmuxから「抜けたい」: `Ctrl-a d`（detach）
  - また戻る: `ai start` / `tgo` / `tnew`
- 再起動後に作業を戻したい: `tnew` で tmux を起動すると、保存済み session が自動復元される
  - 手動保存: `Ctrl-a Ctrl-s`
  - 手動復元: `Ctrl-a Ctrl-r`
  - これらは現状 `tmux-resurrect` のデフォルト keybind

## チュートリアル

- 5〜10分で慣れる: `ttutor`
- 10分 demo: `docs/05-demo-walkthrough.md`
- bootstrap の全体像: `docs/02-bootstrap-flow.md`
- サポート範囲: `docs/31-support-matrix.md`
