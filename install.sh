#!/bin/sh

sudo apt install shc

mkdir -p /root/shc

cd /root/shc || exit

wget http://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.9.tgz

tar xzf shc-3.8.9.tgz

cd shc-3.8.9 || exit

make install

git clone "https://github.com/Konixy/git-sync"

mkdir -p /bin

shc -f ./git-sync/git-sync.sh

cp ./git-sync/git-sync.sh.x /bin/git-sync

chmod +x /bin/git-sync

shc -f ./git-sync/git-remove-branch.sh

cp ./git-sync/git-remove-branch.sh.x /bin/git-remove-branch

chmod +x /bin/git-remove-branch

rm -rf git-sync

export PATH="$PATH:$HOME/bin"

# # shellcheck source=~/.bashrc
# . ~/.bashrc

# # shellcheck source=~/.zshrc
# . ~/.zshrc