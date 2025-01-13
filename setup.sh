#!/bin/zsh

# ---------------------------------
# エラーハンドリングの設定
# ---------------------------------
set -e  # エラー時に即座に終了
trap 'echo "エラーが発生しました。"; exit 1' ERR

# ---------------------------------
# 初期設定
# ---------------------------------
DOTFILES_DIR="$HOME/dotfiles"

# ディレクトリ存在確認
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "エラー: $DOTFILES_DIR が存在しません"
    exit 1
fi

echo "セットアップを開始します..."

# ---------------------------------
# ユーティリティ関数
# ---------------------------------
backup_file() {
    if [ -f "$1" ] && [ ! -L "$1" ]; then
        mv "$1" "$1.backup.$(date +%Y%m%d-%H%M%S)"
        echo "バックアップを作成しました: $1"
    fi
}

check_installation() {
    if ! command -v "$1" &>/dev/null; then
        echo "警告: $1 のインストールに失敗した可能性があります"
        return 1
    fi
}

# ---------------------------------
# Homebrew のインストール
# ---------------------------------
if ! command -v brew &>/dev/null; then
    echo "Homebrew が見つかりません。インストールを開始します..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Homebrew のパス設定
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew は既にインストールされています。"
fi

echo "Homebrew を更新しています..."
brew update

# 必要なツールのインストール
echo "必要なツールをインストールしています..."
brew install git autojump

# インストール確認
check_installation git
check_installation autojump

# ---------------------------------
# Oh My Zsh のインストール
# ---------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh をインストール中..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh は既にインストールされています。"
fi

# ---------------------------------
# カスタムプラグインのインストール
# ---------------------------------
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
mkdir -p "$ZSH_CUSTOM/plugins"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions をインストール中..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions は既にインストールされています。"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting をインストール中..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting は既にインストールされています。"
fi

# ---------------------------------
# 設定ファイルのシンボリックリンク
# ---------------------------------
echo "設定ファイルのバックアップとシンボリックリンクを作成中..."

# 既存ファイルのバックアップとシンボリックリンクの作成
backup_file "$HOME/.zshrc"
backup_file "$HOME/.gitconfig"
backup_file "$HOME/.gitignore"

ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"

echo "シンボリックリンクの作成が完了しました。"

# ---------------------------------
# セットアップ完了
# ---------------------------------
echo "セットアップが完了しました！"
echo "新しい設定を反映するために、以下のいずれかを実行してください："
echo "1. ターミナルを再起動する"
echo "2. 次のコマンドを実行する: exec zsh"
