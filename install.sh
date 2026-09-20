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

# pi's config lives next to its sessions and caches, so the JSON/Markdown files
# are linked separately (see pi/link-config.sh).
"$CWD/pi/link-config.sh"

# eslint resolves a config's plugins relative to the config file, so the shared
# eslint.config.mjs needs its toolchain installed here rather than globally.
if command_exists npm; then
  npm install --prefix "$CWD" --no-fund --no-audit
else
  echo "Warning: npm not found, skipping eslint toolchain install" >&2
fi
echo "dotfiles have been synchronized!"
printf "\nAll done!"
