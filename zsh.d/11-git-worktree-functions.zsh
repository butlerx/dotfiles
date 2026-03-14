#!/usr/bin/env zsh
# -------------------------------------------------------------------
# Git Worktree Functions
# Branch-based worktrees stored as siblings: ../repo.worktrees/branch-name
# Designed for parallel workflows (you + agents working simultaneously)
#
# Usage: gwt <command> [args...]
#
# Commands:
#   add <branch> [base]     Create a worktree for a branch
#   rm <branch>             Remove a worktree
#   cd [branch]             cd into worktree, or return to main with no args
#   list                    List all worktrees
#   status                  Status overview of all worktrees
#   run <branch> <cmd...>   Run a command in a worktree
#   agent <branch> [base]   Get/create worktree path (for any agent/script)
#   clean                   Remove worktrees with merged branches
#   oc <branch> [base]      Open OpenCode TUI in a worktree
#   oc-run <branch> <msg>   Run headless OpenCode task in a worktree
# -------------------------------------------------------------------

# Base directory for worktrees, relative to the repo root's parent
# e.g. ~/code/myproject -> ~/code/myproject.worktrees/
_gwt_base() {
	local toplevel
	toplevel=$(git rev-parse --show-toplevel 2>/dev/null) || {
		echo "Not a git repository" >&2
		return 1
	}
	echo "${toplevel}.worktrees"
}

# Sanitize branch name for use as directory name (feature/foo -> feature-foo)
_gwt_dirname() {
	echo "$1" | tr '/' '-'
}

# Run direnv allow if direnv is installed and .envrc exists in target dir
_gwt_direnv_allow() {
	local dir="$1"
	if command -v direnv &>/dev/null && [[ -f "${dir}/.envrc" ]]; then
		direnv allow "$dir"
	fi
}

# -------------------------------------------------------------------
# Subcommand implementations (prefixed _gwt_ to keep namespace clean)
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# gwt add <branch> [base-branch]
# Create a new worktree for a branch. If the branch doesn't exist,
# it's created from base-branch (default: current branch).
# Copies .env* files, symlinks node_modules, and runs direnv allow.
# -------------------------------------------------------------------
_gwt_add() {
	if [[ $# -lt 1 ]]; then
		echo "Usage: gwt add <branch> [base-branch]" >&2
		echo "  Creates a worktree for <branch>, optionally branching from [base-branch]" >&2
		return 1
	fi

	local branch="$1"
	local base_branch="${2:-$(git rev-parse --abbrev-ref HEAD)}"
	local base_dir
	base_dir=$(_gwt_base) || return 1

	local toplevel
	toplevel=$(git rev-parse --show-toplevel 2>/dev/null) || return 1

	local dir_name
	dir_name=$(_gwt_dirname "$branch")
	local wt_path="${base_dir}/${dir_name}"

	if [[ -d "$wt_path" ]]; then
		echo "Worktree already exists: $wt_path" >&2
		return 1
	fi

	mkdir -p "$base_dir"

	# Check if branch already exists (local or remote)
	if git show-ref --verify --quiet "refs/heads/${branch}" 2>/dev/null; then
		git worktree add "$wt_path" "$branch"
	elif git show-ref --verify --quiet "refs/remotes/origin/${branch}" 2>/dev/null; then
		git worktree add "$wt_path" "$branch"
	else
		git worktree add -b "$branch" "$wt_path" "$base_branch"
	fi

	if [[ $? -ne 0 ]]; then
		echo "Failed to create worktree" >&2
		return 1
	fi

	# --- Agent-friendly environment setup ---
	# Copy .env files (agents often need these)
	for envfile in "${toplevel}"/.env*; do
		[[ -f "$envfile" ]] && cp "$envfile" "$wt_path/"
	done

	# Symlink node_modules if present (avoids duplicate installs)
	if [[ -d "${toplevel}/node_modules" ]] && [[ ! -e "${wt_path}/node_modules" ]]; then
		ln -s "${toplevel}/node_modules" "${wt_path}/node_modules"
		echo "Symlinked node_modules from main worktree"
	fi

	# Allow direnv if .envrc is present
	_gwt_direnv_allow "$wt_path"

	echo "Worktree created: $wt_path"
	echo "  Branch: $branch (from $base_branch)"
	echo "  cd $wt_path"
}

# -------------------------------------------------------------------
# gwt rm <branch>
# Remove a worktree by branch name. Warns on uncommitted changes.
# Cleans up the .worktrees directory if empty.
# -------------------------------------------------------------------
_gwt_rm() {
	if [[ $# -lt 1 ]]; then
		echo "Usage: gwt rm <branch>" >&2
		return 1
	fi

	local branch="$1"
	local base_dir
	base_dir=$(_gwt_base) || return 1

	local dir_name
	dir_name=$(_gwt_dirname "$branch")
	local wt_path="${base_dir}/${dir_name}"

	if [[ ! -d "$wt_path" ]]; then
		echo "No worktree found at: $wt_path" >&2
		return 1
	fi

	# Check for uncommitted changes
	if git -C "$wt_path" status --porcelain 2>/dev/null | grep -q .; then
		echo "Warning: worktree has uncommitted changes!" >&2
		echo -n "Remove anyway? [y/N] "
		read -r confirm
		[[ "$confirm" != [yY] ]] && return 1
	fi

	git worktree remove "$wt_path" --force
	echo "Removed worktree: $wt_path ($branch)"

	# Clean up base dir if empty
	if [[ -d "$base_dir" ]] && [[ -z "$(ls -A "$base_dir" 2>/dev/null)" ]]; then
		rmdir "$base_dir"
	fi
}

# -------------------------------------------------------------------
# gwt list
# List all worktrees with their paths and branches.
# -------------------------------------------------------------------
_gwt_list() {
	git worktree list 2>/dev/null || {
		echo "Not a git repository" >&2
		return 1
	}
}

# -------------------------------------------------------------------
# gwt cd [branch]
# cd into a worktree by branch name.
# With no args, returns to the main worktree if currently in one.
# Runs direnv allow on enter.
# -------------------------------------------------------------------
_gwt_cd() {
	if [[ $# -lt 1 ]]; then
		# No args: return to main worktree
		local current
		current=$(pwd)

		if [[ "$current" == *.worktrees/* ]]; then
			local main_repo="${current%%.worktrees/*}"
			if [[ ! -d "$main_repo/.git" ]] && [[ ! -f "$main_repo/.git" ]]; then
				echo "Could not find main worktree at: $main_repo" >&2
				return 1
			fi
			cd "$main_repo" || return 1
			echo "Back in: $main_repo ($(git rev-parse --abbrev-ref HEAD))"
		else
			echo "Not in a worktree. Usage: gwt cd <branch>" >&2
			return 1
		fi
		return 0
	fi

	local base_dir
	base_dir=$(_gwt_base) || return 1

	local dir_name
	dir_name=$(_gwt_dirname "$1")
	local wt_path="${base_dir}/${dir_name}"

	if [[ ! -d "$wt_path" ]]; then
		echo "No worktree for branch: $1" >&2
		echo "Available:" >&2
		ls -1 "$base_dir" 2>/dev/null | sed 's/^/  /'
		return 1
	fi

	cd "$wt_path" || return 1
	_gwt_direnv_allow "$wt_path"
	echo "Now in: $(pwd) ($(git rev-parse --abbrev-ref HEAD))"
}

# -------------------------------------------------------------------
# gwt run <branch> <command...>
# Run a command inside a worktree without leaving your current directory.
# Great for kicking off builds or tests in another worktree.
# -------------------------------------------------------------------
_gwt_run() {
	if [[ $# -lt 2 ]]; then
		echo "Usage: gwt run <branch> <command...>" >&2
		echo "  Runs a command inside the worktree for <branch>" >&2
		echo "  Example: gwt run feature-x npm test" >&2
		return 1
	fi

	local branch="$1"
	shift
	local base_dir
	base_dir=$(_gwt_base) || return 1

	local dir_name
	dir_name=$(_gwt_dirname "$branch")
	local wt_path="${base_dir}/${dir_name}"

	if [[ ! -d "$wt_path" ]]; then
		echo "No worktree for branch: $branch" >&2
		return 1
	fi

	echo "Running in $wt_path: $*"
	(cd "$wt_path" && eval "$@")
}

# -------------------------------------------------------------------
# gwt agent <branch> [base-branch]
# Idempotent plumbing command for scripting and AI agents.
# Creates a worktree if it doesn't exist, prints the absolute path.
# Works with any agent (OpenCode, Claude Code, Codex, Aider, etc.)
# or any script that needs an isolated worktree path.
#
# Examples:
#   opencode "$(gwt agent feature/auth)"
#   claude --dir "$(gwt agent feature/auth)"
#   codex --dir "$(gwt agent feature/auth)"
# -------------------------------------------------------------------
_gwt_agent() {
	if [[ $# -lt 1 ]]; then
		echo "Usage: gwt agent <branch> [base-branch]" >&2
		echo "  Creates (or locates) a worktree and prints its path" >&2
		echo "  Use with any agent or script: claude --dir \"\$(gwt agent my-branch)\"" >&2
		return 1
	fi

	local branch="$1"
	local base_branch="${2:-$(git rev-parse --abbrev-ref HEAD)}"
	local base_dir
	base_dir=$(_gwt_base) || return 1

	local dir_name
	dir_name=$(_gwt_dirname "$branch")
	local wt_path="${base_dir}/${dir_name}"

	if [[ -d "$wt_path" ]]; then
		echo "$wt_path"
		return 0
	fi

	# Create quietly — agent doesn't need the verbose output
	_gwt_add "$branch" "$base_branch" >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		echo "Failed to create agent worktree" >&2
		return 1
	fi

	echo "$wt_path"
}

# -------------------------------------------------------------------
# gwt clean
# Remove all worktrees whose branches have been merged into main/master.
# Prunes stale worktree metadata.
# -------------------------------------------------------------------
_gwt_clean() {
	local base_dir
	base_dir=$(_gwt_base) || return 1

	# First, prune any stale worktree references
	git worktree prune

	if [[ ! -d "$base_dir" ]]; then
		echo "No worktrees to clean"
		return 0
	fi

	local current_branch
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	local removed=0

	for wt_dir in "${base_dir}"/*(N/); do
		local branch
		branch=$(git -C "$wt_dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
		[[ -z "$branch" ]] && continue

		# Check if branch has been merged into main/master
		local main_branch
		for candidate in main master; do
			if git show-ref --verify --quiet "refs/heads/${candidate}"; then
				main_branch="$candidate"
				break
			fi
		done

		if [[ -n "$main_branch" ]] && git branch --merged "$main_branch" 2>/dev/null | grep -qw "$branch"; then
			echo "Removing merged worktree: ${wt_dir:t} ($branch)"
			git worktree remove "$wt_dir" --force
			((removed++))
		fi
	done

	# Clean up base dir if empty
	if [[ -d "$base_dir" ]] && [[ -z "$(ls -A "$base_dir" 2>/dev/null)" ]]; then
		rmdir "$base_dir"
	fi

	echo "Cleaned $removed worktree(s). Remaining:"
	_gwt_list
}

# -------------------------------------------------------------------
# gwt oc <branch> [base-branch]
# Open OpenCode TUI in a worktree. Creates the worktree if needed.
# Runs direnv allow before launching.
# -------------------------------------------------------------------
_gwt_oc() {
	if [[ $# -lt 1 ]]; then
		echo "Usage: gwt oc <branch> [base-branch]" >&2
		echo "  Opens OpenCode TUI in the worktree for <branch>" >&2
		return 1
	fi

	local wt_path
	wt_path=$(_gwt_agent "$1" "${2:-}") || return 1

	_gwt_direnv_allow "$wt_path"
	echo "Opening OpenCode in: $wt_path ($1)"
	opencode "$wt_path"
}

# -------------------------------------------------------------------
# gwt oc-run <branch> <message...>
# Run a headless OpenCode task in a worktree.
# Creates the worktree if needed. Runs in the background.
# Great for dispatching agent work while you keep coding.
#
# Examples:
#   gwt oc-run feature/auth "implement JWT refresh token rotation"
#   gwt oc-run fix/typos "fix all typos in src/components"
# -------------------------------------------------------------------
_gwt_oc_run() {
	if [[ $# -lt 2 ]]; then
		echo "Usage: gwt oc-run <branch> <message...>" >&2
		echo "  Example: gwt oc-run feature/auth \"implement JWT auth\"" >&2
		return 1
	fi

	local branch="$1"
	shift
	local message="$*"

	local wt_path
	wt_path=$(_gwt_agent "$branch") || return 1

	echo "Dispatching OpenCode agent in: $wt_path ($branch)"
	echo "  Task: $message"
	echo "  Logs: $wt_path/.opencode-run.log"

	# Run in background, capture output to log
	nohup opencode run --dir "$wt_path" "$message" >"${wt_path}/.opencode-run.log" 2>&1 &
	local pid=$!

	echo "  PID:  $pid"
	echo ""
	echo "Check progress: tail -f $wt_path/.opencode-run.log"
	echo "Check result:   gwt run $branch git diff"
}

# -------------------------------------------------------------------
# gwt status
# Show git status for all worktrees at a glance.
# Displays branch, changed file count, and ahead/behind for each.
# -------------------------------------------------------------------
_gwt_status() {
	local base_dir
	base_dir=$(_gwt_base) || return 1

	if [[ ! -d "$base_dir" ]]; then
		echo "No worktrees"
		return 0
	fi

	local toplevel
	toplevel=$(git rev-parse --show-toplevel 2>/dev/null) || return 1

	echo "Main worktree: $toplevel"
	echo "  Branch: $(git rev-parse --abbrev-ref HEAD)"
	echo "  Status: $(git -C "$toplevel" status --porcelain 2>/dev/null | wc -l | tr -d ' ') changed files"
	echo ""

	for wt_dir in "${base_dir}"/*(N/); do
		local branch
		branch=$(git -C "$wt_dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
		local changes
		changes=$(git -C "$wt_dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
		local ahead_behind
		ahead_behind=$(git -C "$wt_dir" rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)

		local ahead=0 behind=0
		if [[ -n "$ahead_behind" ]]; then
			ahead=$(echo "$ahead_behind" | awk '{print $1}')
			behind=$(echo "$ahead_behind" | awk '{print $2}')
		fi

		echo "Worktree: ${wt_dir:t}"
		echo "  Branch: $branch"
		echo "  Status: $changes changed files"
		[[ "$ahead" -gt 0 ]] && echo "  Ahead:  $ahead commit(s)"
		[[ "$behind" -gt 0 ]] && echo "  Behind: $behind commit(s)"
		echo ""
	done
}

# -------------------------------------------------------------------
# gwt - main dispatcher
# -------------------------------------------------------------------
gwt() {
	local cmd="${1:-help}"
	shift 2>/dev/null

	case "$cmd" in
	add) _gwt_add "$@" ;;
	rm) _gwt_rm "$@" ;;
	cd) _gwt_cd "$@" ;;
	list | ls) _gwt_list "$@" ;;
	status | st) _gwt_status "$@" ;;
	run) _gwt_run "$@" ;;
	agent) _gwt_agent "$@" ;;
	clean) _gwt_clean "$@" ;;
	oc) _gwt_oc "$@" ;;
	oc-run) _gwt_oc_run "$@" ;;
	help | --help | -h)
		echo "Usage: gwt <command> [args...]"
		echo ""
		echo "Commands:"
		echo "  add <branch> [base]     Create a worktree for a branch"
		echo "  rm <branch>             Remove a worktree"
		echo "  cd [branch]             cd into worktree, or return to main with no args"
		echo "  list, ls                List all worktrees"
		echo "  status, st              Status overview of all worktrees"
		echo "  run <branch> <cmd...>   Run a command in a worktree"
		echo "  agent <branch> [base]   Get/create worktree path (for any agent/script)"
		echo "  clean                   Remove worktrees with merged branches"
		echo "  oc <branch> [base]      Open OpenCode TUI in a worktree"
		echo "  oc-run <branch> <msg>   Run headless OpenCode task in a worktree"
		echo "  help                    Show this help"
		;;
	*)
		echo "gwt: unknown command '$cmd'" >&2
		echo "Run 'gwt help' for usage" >&2
		return 1
		;;
	esac
}
