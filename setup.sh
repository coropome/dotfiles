#!/bin/bash

# ---------------------------------
# 初期設定
# ---------------------------------
DOTFILES_DIR="$HOME/dotfiles"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

echo "セットアップを開始します..."

# ---------------------------------
# Homebrew のインストール
# ---------------------------------
if ! command -v brew &>/dev/null; then
    echo "Homebrew が見つかりません。インストールを開始します..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew は既にインストールされています。"
fi

echo "Homebrew を更新しています..."
brew update

# 必要なツールのインストール
brew install git zsh autojump

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
# カスタムプラグインのインストール
# ---------------------------------
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
# シンボリックリンクの作成
# ---------------------------------
echo "シンボリックリンクを作成中..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"

# ---------------------------------
# Zsh をデフォルトシェルに設定
# ---------------------------------
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Zsh をデフォルトのシェルに設定します..."
    chsh -s "$(which zsh)"
else
    echo "Zsh は既にデフォルトのシェルです。"
fi

# ---------------------------------
# 設定の反映
# ---------------------------------
echo "設定を反映しています..."
source "$HOME/.zshrc"

echo "セットアップが完了しました！ターミナルを再起動してください。"
