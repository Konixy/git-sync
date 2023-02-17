#!/bin/sh

mkdir -p ~/bin

cp ./git-sync.sh ~/bin/

chmod +x ~/bin/git-sync.sh

cp ./git-remove-branch.sh ~/bin/

chmod +x ~/bin/git-remove-branch.sh

export PATH="$PATH:$HOME/bin"

# # shellcheck source=~/.bashrc
# . ~/.bashrc

# # shellcheck source=~/.zshrc
# . ~/.zshrc