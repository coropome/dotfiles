# CLIツール最小チートシート（ditfiles）

目的：入れたはいいが使わない、を防ぐための「最小だけ」まとめ。

## agent CLI の位置づけ

`make mac` で `node` / `npm` / `uv` / `python3` などの実行環境を揃え、`make agent` で以下の CLI を入れる想定。

```bash
claude --version
gemini --version
codex --version
```

初回はそれぞれログインや API キー設定が必要なことがある。

## rg（ripgrep）: 最強の全文検索

```bash
rg "keyword"                # カレント以下を検索
rg -n "keyword" file.txt    # 行番号付き
rg "TODO|FIXME"             # 正規表現OK
rg --hidden "keyword"       # 隠しファイルも
```

## fd: findの代替（速い）

```bash
fd "name"                   # 名前で探す（正規表現）
fd -t f "\.md$"             # ファイルだけ
fd -t d "src"               # ディレクトリだけ
```

## jq: JSONを読む/抜く

```bash
cat data.json | jq .                          # 整形表示
cat data.json | jq '.items[] | .id'           # フィールド抽出
curl -s URL | jq -r '.name'                   # -rで生文字
```

## gh: GitHub操作（PR/CI確認が速い）

```bash
gh auth status

gh repo view --web

gh pr list
# PRの詳細
# gh pr view <番号> --comments

# 失敗したCIを見る
# gh run list --limit 5
# gh run view <run-id> --log-failed
```

## delta: git diffを読みやすく

ditfilesでは git の pager を delta に寄せている（install時に ~/.gitconfig に include を追加）。

```bash
delta --version
```

## zoxide: cdが速くなる

```bash
zoxide init zsh   # これは設定に入れる用（手で毎回打たない）

z <dir>           # 近いディレクトリへジャンプ（履歴から）
zi                # fzfがあれば対話的
```

ditfilesでは zshrc で自動的に有効化する（zoxideが入っている場合）。

## htop: プロセス監視

```bash
htop
```

## eza: 見やすいls（好み）

```bash
eza -la
```

## p: プロジェクトを選んで `tnew`

```bash
p
```

探索ルートは `DITFILES_PROJECT_ROOTS` で `:` 区切り指定できる。

```bash
export DITFILES_PROJECT_ROOTS="$HOME/work:$HOME/oss:$HOME/dotfiles"
export DITFILES_PROJECT_MAX_DEPTH=4
```

古い `P_ROOTS` も後方互換で受け付けるが、新規設定は `DITFILES_PROJECT_ROOTS` を使う。

## zsh 起動時間の計測

zsh の立ち上がりが遅いと感じたら、`zprof` を有効にして確認できる。

```bash
ZSH_PROFILE=1 zsh -i -c exit
```

関数ごとの実行時間が出るので、重い初期化処理を特定しやすい。


## bat: pretty cat（ccat）

```bash
ccat file.txt
```

※ ditfilesは `cat` を上書きしない（事故防止）。
