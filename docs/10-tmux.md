# tmux

## 目的
- 1ターミナルで分割
- セッションを保って作業を切り替える

## prefix（ditfiles）
- メイン: **Ctrl-a**
- 互換: **Ctrl-b**（tmuxデフォルトの知識がそのまま使える）

## 最初に覚える（ditfilesのおすすめ）
- help: `prefix + ?`
- split: `prefix + |`（縦） / `prefix + -`（横）
- move: `prefix + ←/↓/↑/→`
- next pane: `prefix + Tab`
- detach: `prefix + d`
- save session: `prefix + Ctrl-s`
- restore session: `prefix + Ctrl-r`

※ save / restore は現状 `tmux-resurrect` のデフォルト keybind に依存

※ tmux標準の split（互換）：`prefix + %`（縦） / `prefix + "`（横）

## セッション運用（ハードルを下げる）

### ditfilesコマンド（おすすめ）
- 新規/attach: `tnew`（迷ったらこれ）
- 一覧: `tlist`
- 入る: `tgo`
- 消す: `tkill`

### tmux標準コマンド（世界の共通語）
- 新規: `tmux new -s <name>`
- 一覧: `tmux ls`
- attach: `tmux attach -t <name>`
- kill: `tmux kill-session -t <name>`

## 迷ったら `tnew`

`fzf` があれば選択UI、無ければ番号選択で既存セッションに入れる。
（キャンセルすれば新規作成）

### fzfが無くてもOK

`fzf` が無い場合でも、`tgo` / `tkill` / `tnew` は番号選択で操作できる。

## セッション永続化（再起動後も戻す）

ditfiles では `tmux-resurrect` と `tmux-continuum` を有効にする。

- 1分ごとに自動保存
- 手動保存: `prefix + Ctrl-s`
- 手動復元: `prefix + Ctrl-r`
- Mac 再起動後は、**次に tmux を起動した時** に保存済みセッションを復元する

戻るもの:

- session / window / pane 構成
- pane ごとのカレントディレクトリ
- 一部コマンドとレイアウト

戻らない/戻りにくいもの:

- vim の編集中状態
- 対話アプリの内部状態
- SSH 先の一時状態

なので、「作業空間の骨組みを戻す」機能と考えるのが実態に近い。


## コピー/貼り付け（バッファ）

- バッファ一覧：`prefix + b`
- 最後のバッファを貼り付け：`prefix + p`

copy-mode からシステムクリップボードへ出す時は、bootstrap-managed な `~/.local/bin/_clipboard_copy` を使う。

- macOS: `pbcopy`
- WSL: `clip.exe`
- Linux: `wl-copy` / `xclip` / `xsel`

（詳細は `docs/11-copy-mode.md`）

## Help の互換性

- 新しい tmux では `prefix + ?` / `prefix + /` は popup で開く
- 古い tmux では split pane fallback で開く

どちらも内部的には `~/.local/bin/_tmux_help` を使う。

plugin manager (`tpm`) がまだ入っていない環境では、tmux は plugin bootstrap を読み飛ばして起動だけは継続する。
