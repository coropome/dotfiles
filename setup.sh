#!/bin/bash

# ---------------------------------
# Homebrew のインストール
# ---------------------------------
if ! command -v brew &>/dev/null; then
    echo "Homebrew が見つかりません。インストールを開始します。"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew は既にインストールされています。"
fi

# 必要なツールをインストール
brew update
brew install git zsh

# ---------------------------------
# Oh My Zsh のインストール
# ---------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh をインストール中..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh は既にインストールされています。"
fi

# ---------------------------------
# シンボリックリンクの設定
# ---------------------------------
DOTFILES_DIR="$HOME/dotfiles"

echo "シンボリックリンクを作成中..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"

# ---------------------------------
# Zsh をデフォルトシェルに設定
# ---------------------------------
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Zsh をデフォルトのシェルに設定します。"
    chsh -s "$(which zsh)"
else
    echo "Zsh は既にデフォルトのシェルに設定されています。"
fi

echo "セットアップが完了しました！再ログインして設定を反映してください。"
