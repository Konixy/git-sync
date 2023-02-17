#!/bin/sh

mkdir -p ~/bin

cp ./git-sync.sh ~/bin/

chmod +x ~/bin/git-sync.sh

export PATH="$PATH:$HOME/bin"

# shellcheck source=~/.bashrc
. ~/.bashrc

# shellcheck source=~/.zshrc
. ~/.zshrc