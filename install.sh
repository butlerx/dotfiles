#! /usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE}")"

CWD=$(pwd)

printf "# Syncing to home folder...\n"
git submodule update --init --recursive
pets --conf-dir .
echo "dotfiles have been synchronized!"

echo "Installing Python-based utilities.."
pip install -r "$CWD/requirements.txt"

printf "\nAll done!"
