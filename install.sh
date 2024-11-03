#! /usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE}")"

CWD=$(pwd)

printf "# Syncing to home folder...\n"

function doSync() {
  pets -conf-dir .

  config_dirs=(
    "config/alacritty"
    "config/autorandr"
    "config/autostart"
    "config/libinput-gestures.conf"
    "config/nvim"
    "config/rofi"
    "config/systemd"
    "weechat"
    "zsh-completions"
    "zsh.d"
  )
  for i in "${config_dirs[@]}"; do
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
