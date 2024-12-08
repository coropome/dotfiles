#!/bin/bash

# Create .zsh directory in home folder if it doesn't exist
if ! mkdir -p ~/.zsh; then
    echo "Failed to create ~/.zsh directory"
    exit 1
fi

# Change to .zsh directory
if ! cd ~/.zsh; then
    echo "Failed to change to ~/.zsh directory"
    exit 1
fi

# Clone git repository to a temporary directory
if ! git clone --depth 1 https://github.com/git/git.git temp_git; then
    echo "Failed to clone git repository"
    exit 1
fi

# Copy necessary files
cp temp_git/contrib/completion/git-prompt.sh .
cp temp_git/contrib/completion/git-completion.bash .
cp temp_git/contrib/completion/git-completion.zsh _git

# Remove temporary git repository
rm -rf temp_git

# Set appropriate permissions
chmod 644 _git git-completion.bash git-prompt.sh

# Add to .zshrc if not already present
if ! grep -q "source ~/.zsh/git-prompt.sh" ~/.zshrc; then
    cat >> ~/.zshrc << 'EOL'

# Git integration
source ~/.zsh/git-prompt.sh
source ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit
EOL
fi

echo "Git completion and prompt setup completed successfully"

# キーボード設定

# キーボードの設定を最速にする
# キーのリピート速度を最速に設定 (2が最速, デフォルトは6)
defaults write NSGlobalDomain KeyRepeat -int 2

# キーリピート開始までの遅延を最短に設定 (15が最速, デフォルトは68)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "キーボード設定を変更しました。設定を反映するために再起動してください。"

# Bluetooth メニューバーアイコンを表示
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Bluetooth -int 18

# 音量メニューバーの表示設定
defaults write com.apple.controlcenter Sound -int 18
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

# 設定を反映
killall ControlCenter
killall SystemUIServer

# 時計まわり
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool true