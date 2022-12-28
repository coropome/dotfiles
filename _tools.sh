#!/bin/bash

mkdir -p ~/.zsh
cd ~/.zsh || exit
curl -O https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

curl -O https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -O https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

mv git-completion.zsh _git