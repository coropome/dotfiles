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
  zsh-syntax-highlighting # コマンドの構文強調表示
)

# Oh My Zsh をロード
source $ZSH/oh-my-zsh.sh

# ---------------------------------------
# カスタムエイリアス
# ---------------------------------------

# よく使うコマンドを短縮
alias ll='ls -la'                # 詳細なファイル一覧
alias gs='git status'            # Git ステータス確認
alias ga='git add .'             # 全ファイル追加
alias gp='git push'              # Git プッシュ
alias gl='git log --oneline'     # Git の簡易ログ
alias cd..='cd ..'               # 1階層上に移動

# VS Code 用エイリアス
alias codez="code ~/.zshrc"      # .zshrc を VS Code で開く
alias reloadz="source ~/.zshrc"  # .zshrc を再読み込み

# Python のエイリアス
alias python='python3'

# aws-vault のエイリアス
alias av='aws-vault exec'

# ---------------------------------------
# ターミナルの見た目と動作設定
# ---------------------------------------

# 補完待機中の表示設定
COMPLETION_WAITING_DOTS="true"

# コマンド履歴の日付フォーマット
HIST_STAMPS="yyyy-mm-dd"

# ls コマンドのカラーを有効化
export LSCOLORS="ExFxBxDxCxegedabagacad"

# ターミナルタイトルの自動設定を無効化
DISABLE_AUTO_TITLE="true"

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

# Ctrl+R での履歴検索を有効化
bindkey '^R' history-incremental-search-backward

# HSTR (hh) の設定
alias hh=hstr
setopt histignorespace
export HSTR_CONFIG=hicolor
bindkey -s "\C-r" "\C-a hstr -- \C-j"
export HSTR_TIOCSTI=y

# zsh-autosuggestions の読み込み
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting の読み込み
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
