#!/usr/bin/env zsh
# pets: symlink=~/.pi/agent/extensions/subagent/gwt-worktree-setup.zsh
# pi-subagents worktreeSetupHook: apply gwt's environment setup
# (.envrc.gwt, direnv allow, symlinked deps) to a pi-created worktree.
# stdin: {repoRoot, worktreePath, ...}. stdout must be one JSON object listing
# the files we created, so pi excludes them from the agent's diff.
input=$(cat)
repo=$(jq -r .repoRoot <<<"$input")
wt=$(jq -r .worktreePath <<<"$input")

source ~/.dotfiles/zsh.d/11-git-worktree-functions.zsh
_gwt_setup_env "$repo" "$wt" >&2

git -C "$wt" ls-files -o --exclude-standard |
	sed 's:/$::' |
	grep -E '(^|/)(\.envrc|\.envrc\.gwt|node_modules|\.venv|vendor)$' |
	jq -R . | jq -sc '{syntheticPaths: .}'
