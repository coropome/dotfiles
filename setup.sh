#!/bin/bash

# エラーが発生したら即座に終了
set -e

# ログ出力用の関数
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# エラーハンドリング
error_handler() {
    log "エラーが発生しました: $1"
    exit 1
}

# コマンドの存在確認
check_command() {
    if ! command -v "$1" &> /dev/null; then
        error_handler "$1 が見つかりません"
    fi
}

# Xcodeインストール
log "Xcodeコマンドラインツールのインストールを確認中..."
if ! xcode-select -p &> /dev/null; then
    log "Xcodeコマンドラインツールをインストールします..."
    xcode-select --install
    # インストールダイアログが表示されるため、ユーザーの操作を待つ
    read -p "Xcodeのインストールが完了したらEnterを押してください..."
fi

# Rosettaのインストール
log "Rosetta 2のインストールを開始します..."
if ! pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto &> /dev/null; then
    sudo softwareupdate --install-rosetta --agree-to-license
fi

# Homebrewのインストール
log "Homebrewの確認とインストール..."
if ! command -v brew &> /dev/null; then
    log "Homebrewをインストールします..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon Macの場合のPATH設定
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Homebrewのセットアップと更新
log "Homebrewの診断を実行します..."
brew doctor || true  # エラーが出ても続行

log "Homebrewをアップデートします..."
brew update --verbose

log "Homebrewパッケージをアップグレードします..."
brew upgrade --verbose

# Brewfileからのインストール
if [ -f "./.Brewfile" ]; then
    log ".Brewfileからパッケージをインストールします..."
    brew bundle --file ./.Brewfile --verbose
else
    log ".Brewfileが見つかりません"
fi

# クリーンアップ
log "不要なファイルを削除します..."
brew cleanup --verbose

# 追加ツールのインストール
if [ -f "./_tools.sh" ]; then
    log "追加ツールをインストールします..."
    chmod +x ./_tools.sh
    ./_tools.sh
else
    log "_tools.shが見つかりません"
fi

# シンボリックリンクの作成
if [ -f "./_link.sh" ]; then
    log "シンボリックリンクを作成します..."
    chmod +x ./_link.sh
    ./_link.sh
else
    log "_link.shが見つかりません"
fi

# シェルの再起動
log "セットアップが完了しました。シェルを再起動します..."
exec $SHELL -l
