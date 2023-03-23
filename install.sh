#! /usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE}")"

CWD=$(pwd)

printf "# Syncing to home folder...\n"

function doSync() {
  configs=(
    "Xmodmap"
    "Xresources"
    "config/autorandr"
    "config/flake8"
    "config/kitty"
    "config/libinput-gestures.conf"
    "config/nvim"
    "config/polybar"
    "config/rofi"
    "config/systemd"
    "eslintrc.js"
    "gitconfig"
    "gtkrc-3.0"
    "i3"
    "prettierrc.js"
    "ssh"
    "tmux"
    "tmux.conf"
    "vimrc"
    "weechat"
    "xbindkeysrc"
    "xinitrc"
    "zsh-completions"
    "zsh.d"
    "zshrc"
  )
  for i in "${configs[@]}"; do
    ln -sf "$CWD/${i}" "$HOME/.${i}"
  done
  return 0
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  doSync
else
  read -rp "This may overwrite existing files in your home directory. Are you sure? (y/N) " -n 1
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

printf "\nAll done!"
