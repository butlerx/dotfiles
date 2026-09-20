#!/usr/bin/env bash
#
# Link pi's global config files into ~/.pi/agent.
#
# pi keeps settings alongside sessions, caches and auth.json in ~/.pi/agent, so
# the directory itself cannot be symlinked. JSON and Markdown files cannot carry
# a pets modeline comment either, so these four are linked here instead. The
# agents/, skills/ and themes/ directories are handled by pets via .petsfile.
#
# Run by install.sh; safe to run on its own at any time.

set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest="${PI_AGENT_DIR:-$HOME/.pi/agent}"

mkdir -p "$dest"

for file in settings.json settings-extensions.json mcp.json AGENTS.md; do
  target="$dest/$file"
  if [[ -L "$target" ]]; then
    [[ "$(readlink "$target")" == "$src/$file" ]] && continue
  elif [[ -e "$target" ]]; then
    mv "$target" "$target.pets-backup"
    echo "backed up $target -> $target.pets-backup"
  fi
  ln -sfn "$src/$file" "$target"
  echo "linked $target -> $src/$file"
done
