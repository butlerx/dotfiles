#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

CWD=$(pwd)
OS="$(uname -s)"

command_exists() {
  command -v "$1" &>/dev/null
}

printf "# Syncing to home folder...\n"
git submodule update --init --recursive

if command_exists pets; then
  pets --conf-dir .
  pets completions zsh >"$CWD/zsh-completions/_pets"
else
  echo "Error: pets not found. Install with: cargo install pets-configurator" >&2
  exit 1
fi
echo "dotfiles have been synchronized!"
printf "\nAll done!"
