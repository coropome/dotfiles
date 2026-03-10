# iTerm2（初心者でも崩れない最小設定）

このリポジトリは iTerm2 を「最初から tmux で使う」前提。
ここでは *設定を盛りすぎない* ことを最優先にする。

## ゴール

- 日本語/記号幅が崩れない
- コピペで事故らない
- ショートカットの主導権は tmux（iTerm2 で魔改造しない）

## 推奨設定（最小）

### 1) プロファイル（Profiles）

- `Profiles` → `General`
  - **Working Directory**: `Reuse previous session's directory`（好み）

### 2) フォント（Text）

- `Profiles` → `Text`
  - Font: 好きな等幅フォント

日本語混在が多いなら、まずは以下が無難（好みでOK）：
- **JetBrains Mono** + 日本語は OS 任せ（まずは崩れなければOK）

※「見た目の最強」より「崩れない」を優先。

### 3) ペースト安全（General）

- `Preferences` → `General` → `Magic`
  - **Warn before pasting one line ending in a newline**: ON（おすすめ）
  - **Warn before pasting multiple lines**: ON（おすすめ）

（うっかり危険コマンドを貼って実行、を避ける）

### 4) Optionキー（Keys）

- `Preferences` → `Profiles` → `Keys`
  - **Left/Right Option key**: `Esc+`（Meta）にしたい場合は設定

※ tmux + shell のキーバインドを多用するなら Meta が便利。
※ 逆に Mac 標準ショートカットを多用する人は無理に変えない。

### 5) キーバインドは増やさない

- iTerm2側で pane 分割などを作り込まない
- 分割・移動は tmux（`Ctrl-a ...`）に寄せる

## 設定を丸ごとバックアップして GitHub に置く

「新しい Mac に完全移行したい」「設定を取りこぼしたくない」なら、
**`Settings > General > Settings > Export All Settings and Data`** を使う。

iTerm2 公式 docs では、この export に以下が含まれる:

- Settings window の設定全体
- secure user defaults
- `~/.iterm2`
- `~/Library/Application Support/iTerm2`
- Python API runtimes / scripts

つまり、**見た目設定だけでなく iTerm2 周辺データもかなり広く入る**。
このため、GitHub に置くなら **public repo ではなく private repo 推奨**。
これは公式 docs の「含まれる範囲」からの実務上の判断。

### エクスポート手順

1. iTerm2 を開く
2. `Settings` → `General` → `Settings`
3. **`Export All Settings and Data`** を押す
4. 保存先を GitHub に上げるローカル repo 配下にする
   例: `~/src/your-private-repo/iterm2/backup/`
5. 分かりやすい名前で保存する
   例: `iterm2-all-settings-2026-03-10`
6. その repo を commit / push する

例:

```bash
cd ~/src/your-private-repo
git add iterm2/backup/
git commit -m "backup: refresh iTerm2 settings export"
git push
```

### 新しい Mac での手動インポート

1. iTerm2 をインストールして一度起動する
2. GitHub から backup を置いた repo を clone / pull する
3. iTerm2 で `Settings` → `General` → `Settings` を開く
4. **`Import All Settings and Data`** を押す
5. GitHub から落としてきた export ファイルを選ぶ
6. iTerm2 を再起動する

これで「完全移行」にかなり近い形で戻せる。

### 運用メモ

- 人が読む差分を残したいなら、完全 export とは別に profile 単位の JSON も保存するとよい
- profile 単位の JSON は `Settings > Profiles` で profile を選び、`Other Actions` から **`Save Profile as JSON`** を使う
- Dynamic Profiles を使う場合、iTerm2 公式 docs では `~/Library/Application Support/iTerm2/DynamicProfiles` を監視して即時 reload するとされている

## tmuxとの相性メモ

- iTerm2 のタブ/ウィンドウ管理はそのまま使ってOK
- 画面内の分割・作業セッションは tmux に寄せると混乱が減る
