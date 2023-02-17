#!/bin/sh

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  echo "Linux detected"

  if ! which shc >/dev/null; then
    sudo apt update --allow
    sudo apt install --allow shc make build-essential git curl

    mkdir -p /root/shc

    cd /root/shc || exit

    curl -o shc.tgz http://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.9.tgz

    tar xzf shc.tgz

    cd shc || exit

    make install
  fi

  INSTALL_DIRECTORY="$HOME/bin"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Mac OS X detected"

  if command -v brew >/dev/null 2>&1; then
    echo "Installing shc with brew"
    brew install shc
    INSTALL_DIRECTORY="$HOME/.local/bin"
  else
    echo "Please install brew"
    exit 1
  fi
else
  echo "Unknown operating system: $OSTYPE"
  exit 1
fi

git clone "https://github.com/Konixy/git-sync" git-sync-repo

INSTALL_DIRECTORY="$HOME/.local/bin"

mkdir -p "$INSTALL_DIRECTORY"

shc -f ./git-sync-repo/git-sync.sh

sudo cp ./git-sync-repo/git-sync.sh.x "$INSTALL_DIRECTORY"/git-sync

chmod +x "$INSTALL_DIRECTORY"/git-sync

shc -f ./git-sync-repo/git-remove-branch.sh

sudo cp ./git-sync-repo/git-remove-branch.sh.x "$INSTALL_DIRECTORY"/git-remove-branch

chmod +x "$INSTALL_DIRECTORY"/git-remove-branch

rm -rf git-sync-repo

export PATH="$PATH:$INSTALL_DIRECTORY"

# shellcheck source=~/.bashrc
. ~/.bashrc

# shellcheck source=~/.zshrc
. ~/.zshrc