#!/bin/bash

# エラーハンドリング
set -e
trap 'echo "Error: Something went wrong!"' ERR

# カラー表示用
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# ヘルプメッセージ
function show_help() {
    echo "Usage: ./setup.sh [option]"
    echo ""
    echo "Options:"
    echo "  install      Install required tools and packages"
    echo "  link         Create symbolic links for dotfiles"
    echo "  theme        Apply terminal theme"
    echo "  all          Run all steps (default)"
    echo "  help         Show this help message"
}

# パッケージのインストール
function install_tools() {
    echo -e "${GREEN}Installing required tools...${NC}"
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew found, installing packages..."
        brew bundle --file=.Brewfile
    else
        echo "Homebrew not found. Please install it first."
        exit 1
    fi
}

# シンボリックリンク作成
function create_links() {
    echo -e "${GREEN}Creating symbolic links...${NC}"
    ln -sf "$(pwd)/.zshrc" "$HOME/.zshrc"
    ln -sf "$(pwd)/.vimrc" "$HOME/.vimrc"
    ln -sf "$(pwd)/.gitconfig" "$HOME/.gitconfig"
}

# ターミナルテーマ適用
function apply_theme() {
    echo -e "${GREEN}Applying terminal theme...${NC}"

    # ユーザーに手動でテーマをインポートしてもらう案内
    echo -e "${GREEN}Please import the 'theme.terminal' file into your Terminal preferences.${NC}"
    echo -e "${GREEN}After importing the theme, set it as the default profile and restart your Terminal manually.${NC}"
}

# メイン処理
case "$1" in
    install)
        install_tools
        ;;
    link)
        create_links
        ;;
    theme)
        apply_theme
        ;;
    all|"")
        install_tools
        create_links
        apply_theme
        ;;
    help)
        show_help
        ;;
    *)
        echo -e "${RED}Invalid option: $1${NC}"
        show_help
        exit 1
        ;;
esac

echo -e "${GREEN}Setup completed successfully!${NC}"
