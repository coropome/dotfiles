# ==================================
# 基本設定
# ==================================

# パス設定
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

# 環境変数の設定
export EDITOR="code --wait"
export LANG="ja_JP.UTF-8"
export LC_ALL="ja_JP.UTF-8"
export ZSH="$HOME/.oh-my-zsh"

# ==================================
# パフォーマンス最適化
# ==================================

# Git状態チェックの高速化
DISABLE_UNTRACKED_FILES_DIRTY="true"

# 補完システムの最適化
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ==================================
# Oh My Zsh の設定
# ==================================

ZSH_THEME="robbyrussell"

# 必要なプラグイン
plugins=(
  git                        # Gitコマンドの補完と省略形
  zsh-autosuggestions       # コマンド入力の提案機能
  zsh-syntax-highlighting   # シンタックスハイライト
  autojump                  # ディレクトリ間の素早い移動
  history-substring-search  # 履歴検索の強化
  docker                    # Dockerコマンドの補完
  kubectl                   # Kubernetes補完
  npm                       # npm補完
)

source $ZSH/oh-my-zsh.sh

# ==================================
# 履歴の設定
# ==================================

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt EXTENDED_HISTORY          # タイムスタンプを記録
setopt HIST_EXPIRE_DUPS_FIRST   # 重複する履歴を優先的に削除
setopt HIST_IGNORE_DUPS         # 直前と同じコマンドは記録しない
setopt HIST_IGNORE_ALL_DUPS     # 重複するコマンドは古い方を削除
setopt HIST_FIND_NO_DUPS        # 履歴検索で重複を表示しない
setopt HIST_SAVE_NO_DUPS        # 重複するコマンドを保存しない
setopt SHARE_HISTORY            # セッション間で履歴を共有
setopt HIST_REDUCE_BLANKS       # 余分な空白を削除

# ==================================
# エイリアス設定
# ==================================

# ディレクトリ操作
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -laG'
alias la='ls -laG'
alias ls='ls -G'

# Git操作の短縮形
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'

# 開発関連
alias python=python3
alias pip=pip3
alias codez="code ~/.zshrc"
alias reloadz="source ~/.zshrc"

# AWS
alias av='aws-vault exec'

# ==================================
# カスタム関数
# ==================================

# ディレクトリを作成して移動
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# カレントディレクトリをZIP化
ziphere() {
  zip -r "${PWD##*/}.zip" .
}

# ゴミ箱に移動（安全な削除）
trash() {
  mv "$@" ~/.Trash/
}

# 様々な圧縮ファイルを展開
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz)  tar xzf $1 ;;
      *.bz2)     bunzip2 $1 ;;
      *.rar)     unrar x $1 ;;
      *.gz)      gunzip $1 ;;
      *.tar)     tar xf $1 ;;
      *.tbz2)    tar xjf $1 ;;
      *.tgz)     tar xzf $1 ;;
      *.zip)     unzip $1 ;;
      *.Z)       uncompress $1 ;;
      *)         echo "'$1'は展開できないファイルです" ;;
    esac
  else
    echo "'$1'は有効なファイルではありません"
  fi
}

# ==================================
# 見た目とプロンプトの設定
# ==================================

# lsコマンドの色設定
export LSCOLORS="ExFxBxDxCxegedabagacad"
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# Git情報を含むカスタムプロンプト
git_prompt_info() {
    local git_info=""
    
    # Gitリポジトリ内かチェック
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        # ブランチ名を取得
        local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        
        # ステータスチェック
        local status_symbol=""
        if git diff --quiet 2>/dev/null; then
            status_symbol="%{$fg[green]%}✔%{$reset_color%}"  # 変更がない場合は緑の ✔
        else
            status_symbol="%{$fg[red]%}✘%{$reset_color%}"  # 変更がある場合は赤の ✘
        fi
        
        if [[ -n "$current_branch" ]]; then
            # ブランチ名と状態を表示
            git_info=" %{$fg[yellow]%}[$current_branch]%{$reset_color%} $status_symbol"
        fi
        
        echo "$git_info"
    fi
}

# プロンプトの設定（1行表示、相対パス）
PROMPT='%{$fg[green]%}%~%{$reset_color%} '                      # 相対パス
PROMPT+='%{$fg[magenta]%}$(git_prompt_info)%{$reset_color%} '    # Git情報
PROMPT+='%{$fg[blue]%}→%{$reset_color%} '                         # プロンプトの矢印

# ==================================
# 補完システム
# ==================================

# 補完機能の読み込み
autoload -Uz compinit && compinit

# ドットファイルを補完対象に含める
setopt globdots

# 補完の詳細設定
zstyle ':completion:*' menu select              # 補完をメニュー形式で表示
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # 大文字小文字を区別しない
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  # 補完候補に色を付ける
zstyle ':completion:*' group-name ''           # グループ名を表示
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'  # 補完グループの説明
zstyle ':completion:*:warnings' format '%B一致するものがありません: %d%b'  # 一致がない場合のメッセージ
zstyle ':completion:*' special-dirs true       # ..や.を補完候補に含める
zstyle ':completion:*' file-patterns '%p(D):globbed-files' '*(-/):directories'  # ドットファイルとディレクトリを補完

# ==================================
# Homebrewの設定
# ==================================

eval "$(/opt/homebrew/bin/brew shellenv)"
