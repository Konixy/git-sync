#!/bin/sh

git clone "https://github.com/Konixy/git-sync"

mkdir -p ~/bin

cp ./git-sync/git-sync.sh ~/bin/

chmod +x /bin/git-sync.sh

cp ./git-sync/git-remove-branch.sh ~/bin/

rm -rf git-sync

chmod +x /bin/git-remove-branch.sh

export PATH="$PATH:$HOME/bin"

# # shellcheck source=~/.bashrc
# . ~/.bashrc

# # shellcheck source=~/.zshrc
# . ~/.zshrc