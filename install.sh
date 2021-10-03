#! /usr/bin/env bash
ln -s ./config ~/.config

set -e

cd "$(dirname "${BASH_SOURCE}")"

CWD=$(pwd)

printf "# Syncing to home folder...\n"

function syncFile() {
  local sourceFile="$1"
  ln -sf "$CWD/${sourceFile}" "$HOME/.${sourceFile}"
}

function doSync() {
  syncFile "Xmodmap"
  syncFile "Xresources"
  syncFile "config"
  syncFile "eslintrc.js"
  syncFile "gitconfig"
  syncFile "gtkrc-3.0"
  syncFile "i3"
  syncFile "powerlevel9k"
  syncFile "prettierrc.js"
  syncFile "ssh"
  syncFile "tmux"
  syncFile "tmux.conf"
  syncFile "vimrc"
  syncFile "weechat"
  syncFile "xbindkeysrc"
  syncFile "xinitrc"
  syncFile "zsh-completions"
  syncFile "zsh.d"
  syncFile "zshrc"
  return 0
}
if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  doSync
else
  read -rp "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doSync
  else
    printf "Aborted.\n\n"
    exit 0
  fi
fi
unset doSync

echo "dotfiles have been synchronized!"

echo "Installing Python-based utilities.."
pip install -r "$CWD/requirements.txt"

echo ""
echo "All done!"
