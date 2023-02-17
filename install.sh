#!/bin/sh

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  echo "Linux detected"

  sudo apt install shc

  mkdir -p /root/shc

  cd /root/shc || exit

  wget http://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.9.tgz

  tar xzf shc-3.8.9.tgz

  cd shc-3.8.9 || exit

  make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Mac OS X detected"

  if command -v brew >/dev/null 2>&1; then
    brew install shc
  else
    echo "Please install brew"
    exit 1
  fi
else
  echo "Unknown operating system: $OSTYPE"
  exit 1
fi

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