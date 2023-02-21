#!/bin/sh

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  echo "Linux detected"

  if ! which shc >/dev/null; then
    sudo apt update -y
    sudo apt install -y shc make build-essential git curl

    sudo mkdir -p /root/shc

    sudo curl -o /root/shc/shc.tgz http://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.9.tgz

    sudo tar xzf /root/shc/shc.tgz -C /root/shc/

    make -i /root/shc/shc-3.8.9 install
  fi

  INSTALL_DIRECTORY="/usr/bin"
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

mkdir -p "$INSTALL_DIRECTORY"

shc -f ./git-sync-repo/git-sync.sh

sudo cp ./git-sync-repo/git-sync.sh.x "$INSTALL_DIRECTORY"/git-sync

sudo chmod +x "$INSTALL_DIRECTORY"/git-sync

shc -f ./git-sync-repo/git-remove-branch.sh

sudo cp ./git-sync-repo/git-remove-branch.sh.x "$INSTALL_DIRECTORY"/git-remove-branch

sudo chmod +x "$INSTALL_DIRECTORY"/git-remove-branch

rm -rf git-sync-repo

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.local/bin"

# shellcheck source=~/.bashrc
. ~/.bashrc >/dev/null

# shellcheck source=~/.zshrc
. ~/.zshrc >/dev/null