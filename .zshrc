# ---------------------------------------
# 基本設定
# ---------------------------------------

# パスの設定
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

# デフォルトのエディタ
export EDITOR="code --wait"

# 言語環境
export LANG="ja_JP.UTF-8"
export LC_ALL="ja_JP.UTF-8"

# Oh My Zsh のインストールパス
export ZSH="$HOME/.oh-my-zsh"

# ---------------------------------------
# Oh My Zsh の設定
# ---------------------------------------

# 使用するテーマ
ZSH_THEME="robbyrussell"

# プラグインの設定
plugins=(
  git                 # Git サポート
  zsh-autosuggestions # コマンド補完
  zsh-syntax-highlighting # コマンドの構文強調
)

# Oh My Zsh をロード
source $ZSH/oh-my-zsh.sh

# ---------------------------------------
# カスタムエイリアス
# ---------------------------------------

# よく使うコマンドを短縮
alias ll='ls -laG'                # 詳細なファイル一覧（カラー表示）
alias gs='git status'             # Git ステータス確認
alias ga='git add .'              # 全ファイル追加
alias gp='git push'               # Git プッシュ
alias gl='git log --oneline'      # Git の簡易ログ
alias cd..='cd ..'                # 1階層上に移動

# VS Code 用エイリアス
alias codez="code ~/.zshrc"       # .zshrc を VS Code で開く
alias reloadz="source ~/.zshrc"   # .zshrc を再読み込み

# AWS Vault の省略形
alias av='aws-vault exec'

# Python のエイリアス
alias python=python3

# ---------------------------------------
# ターミナルの見た目と動作設定
# ---------------------------------------

# 補完待機中の表示設定
COMPLETION_WAITING_DOTS="true"

# ls コマンドのカラーを有効化
export LSCOLORS="ExFxBxDxCxegedabagacad"

# ---------------------------------------
# ヒストリ設定
# ---------------------------------------

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ヒストリを共有する
setopt share_history
setopt append_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

# ヒストリ検索のキー設定
bindkey '^R' history-incremental-search-backward

# ---------------------------------------
# ユーザー定義の関数
# ---------------------------------------

# 現在のディレクトリを ZIP 圧縮
function ziphere() {
  zip -r "${PWD##*/}.zip" .
}

# ゴミ箱に移動する（rm の代わり）
function trash() {
  mv "$@" ~/.Trash/
}

# ---------------------------------------
# Homebrew 設定
# ---------------------------------------

# Homebrew の環境変数
eval "$(/opt/homebrew/bin/brew shellenv)"
export EDITOR='code --wait'
