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
    open "$(pwd)/theme.terminal"
    echo "Please set the imported theme as default in terminal preferences."
}

# Oh My Zsh のセットアップ
function setup_oh_my_zsh() {
    echo -e "${GREEN}Setting up Oh My Zsh...${NC}"

    # ~/.zshrc が存在しない場合は作成
    if [ ! -f ~/.zshrc ]; then
        echo "Creating a new .zshrc file..."
        touch ~/.zshrc
    fi

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh My Zsh is already installed."
    fi

    echo "Installing Zsh plugins..."
    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions || true
    git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting || true

    echo "Configuring .zshrc for Oh My Zsh..."
    if ! grep -q "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" ~/.zshrc; then
        sed -i '' 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc || true
    fi

    echo "Updating Zsh theme to 'agnoster'..."
    sed -i '' 's/^ZSH_THEME=".*"/ZSH_THEME="agnoster"/' ~/.zshrc || true
}

# VS Code のセットアップ
function setup_vscode() {
    echo -e "${GREEN}Setting up Visual Studio Code...${NC}"

    # デフォルトエディタを VS Code に設定
    if [ ! -f ~/.zshrc ]; then
        echo "Creating a new .zshrc file..."
        touch ~/.zshrc
    fi

    if ! grep -q "export EDITOR='code --wait'" ~/.zshrc; then
        echo "export EDITOR='code --wait'" >> ~/.zshrc
    fi
    git config --global core.editor "code --wait"

    # VS Code 拡張機能のインストール
    echo "Installing VS Code extensions..."
    code --install-extension ms-python.python
    code --install-extension ms-vscode.cpptools
    code --install-extension esbenp.prettier-vscode
    code --install-extension eamodio.gitlens
    code --install-extension ms-azuretools.vscode-docker
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
        setup_oh_my_zsh
        setup_vscode
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
