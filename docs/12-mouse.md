# tmux のマウス（mouse on）

ditfiles はデフォルトで `mouse on`。クリックでペイン選択、ホイールアップで scrollback、ドラッグでリサイズが使える。

## トグル

`prefix + m` でマウスの ON/OFF を切り替えられる。

## mouse on にすると嬉しいこと
- ペインのクリック移動
- ホイールアップで scrollback
- リサイズ

## 反映されないとき

既存 session は古い設定のまま残ることがある。

```bash
tmux source-file ~/.config/tmux/tmux.conf
tmux show -gv mouse
```

tmux 内なら `prefix + r` でもリロードできる。

## mouse on にすると困ること
- iTerm2の範囲選択でコピーしたいのに、tmuxが掴んでしまう

対処：
- **Shift + ドラッグ**（iTerm2側の選択）
- または `prefix + m` で一時的にマウスをOFFにする

## マウスを常時OFFにしたい場合

`~/.config/ditfiles/local.tmux.conf` に以下を書く（repoには入らない）：

```tmux
set -g mouse off
```

反映は `prefix + r`（tmux.conf のリロード）。
