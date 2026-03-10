# tmux コピーモード（スクロール＆コピー） + バッファ（貼り付け）

目的：ログが流れても、tmux内で落ち着いて「過去ログを見て」「必要な部分をコピー」して、すぐ貼り付けられるようにする。

## 入り方（コピーモード）

- `prefix + [`（tmux標準）

※ prefix は **Ctrl-a**（互換: Ctrl-b もOK）
※ `prefix + c` は tmux標準で "new-window" なので、ditfilesではコピーモードに割り当てない

## 最小で覚える（おすすめ）

### スクロールして読む
- 下/上：`j` / `k`
- 半ページ：`Ctrl-d` / `Ctrl-u`
- 検索：`/` → Enter（次へ：`n`）

### コピー（システムクリップボードへ）

ditfiles のデフォルト：
- 選択開始：`Space`
- 範囲を伸ばす：移動（`h/j/k/l` または矢印）
- コピーして終了：`Enter` または `y`

内部では `~/.local/bin/_clipboard_copy` を使って、環境ごとに以下へ振り分ける。

- macOS: `pbcopy`
- WSL: `clip.exe`
- Linux: `wl-copy` / `xclip` / `xsel`

コピーしたら、普段どおり OS 側の貼り付けを使う。

- macOS: `Cmd+V`
- Linux / WSL: desktop 環境側の paste

## バッファ（tmux内のコピー履歴）

tmuxは「コピーした内容」を **バッファ**として保持できる。

ditfiles のおすすめショートカット：
- **最後にコピーしたバッファを貼り付け**：`prefix + p`
- **バッファ一覧を開く**：`prefix + b`

使い所：
- コピーモードで取った断片を、tmux内でサクサク貼る
- 過去にコピーしたものをもう一回貼る
