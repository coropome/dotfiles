# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/

########################################
# 環境変数
export LANG=ja_JP.UTF-8

# 色を使用出来るようにする
autoload -Uz colors
colors

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "

# 単語の区切り文字を指定する
# autoload -Uz select-word-style
# select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
# zstyle ':zle:*' word-chars " /=;@:{},|"
# zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
 zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# vcs_info
# autoload -Uz vcs_info
# autoload -Uz add-zsh-hook

# zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
# zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

# function _update_vcs_info_msg() {
#    LANG=en_US.UTF-8 vcs_info
#    RPROMPT="${vcs_info_msg_0_}"
# }
# add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
# 日本語ファイル名を表示可能にする
# setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
# setopt no_flow_control

# Ctrl+Dでzshを終了しない
# setopt ignore_eof

# '#' 以降をコメントとして扱う
# setopt interactive_comments

# ディレクトリ名だけでcdする
# setopt auto_cd

# cd したら自動的にpushdする
# setopt auto_pushd
# 重複したディレクトリを追加しない
# setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

export LSCOLORS=Gxfxcxdxbxegedabagacad
alias ls="ls -G"
alias ll="ls -lG"
alias la="ls -laG"

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# 個別設定

# homebrew 用
eval "$(/opt/homebrew/bin/brew shellenv)"

# git の補完機能
fpath+=($(brew --prefix)/share/zsh+/site-functions)

# aws cli の補完機能
autoload bashcompinit && bashcompinit
complete -C '/opt/homebrew/bin/aws_completer' aws

# Terraform の補完機能
complete -o nospace -C /opt/homebrew/Cellar/tfenv/2.2.3/versions/1.1.6/terraform terraform
complete -o nospace -C /opt/homebrew/Cellar/tfenv/2.2.3/versions/1.0.11/terraform terraform
complete -o nospace -C /opt/homebrew/Cellar/tfenv/2.2.3/versions/0.15.3/terraform terraform
complete -o nospace -C /opt/homebrew/Cellar/tfenv/2.2.3/versions/0.13.5/terraform terraform

# git-promptの読み込み
source ~/.zsh/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

# プロンプトのオプション表示設定
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

setopt PROMPT_SUBST ; PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s)")%f
\$ '

# python
alias python=python3


# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

bindkey '^R' history-incremental-search-backward

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="~/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
