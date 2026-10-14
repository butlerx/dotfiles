#!/bin/bash
#
# Create a new git worktree using gwt (~/.dotfiles/zsh.d/11-git-worktree-functions.zsh).
#
# Worktrees live beside the repo at ../<repo>.worktrees/<branch> (slashes become
# dashes). gwt handles environment setup: .envrc.gwt, direnv allow (using the
# main checkout's .envrc), and symlinked node_modules/.venv/vendor.
#
# This wrapper only adds fetching from-branch so the new branch starts at
# origin/<from-branch> without touching the main checkout.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: worktree-manager.sh create <branch-name> [from-branch]

Creates ../<repo>.worktrees/<branch-name> with <branch-name> branched from
[from-branch] (default: origin's default branch, or main).

The main repo checkout is not modified; from-branch is fetched but
not checked out.
EOF
}

get_default_branch() {
  local head_ref
  head_ref=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null || true)
  if [[ -n "$head_ref" ]]; then
    echo "${head_ref#refs/remotes/origin/}"
  else
    echo "main"
  fi
}

create_worktree() {
  local branch_name="${1:-}"
  local from_branch="${2:-}"

  if [[ -z "$branch_name" ]]; then
    echo "Error: branch name required" >&2
    usage >&2
    exit 1
  fi

  from_branch="${from_branch:-$(get_default_branch)}"

  # Fetch from-branch without touching the main checkout.
  if ! git fetch origin "$from_branch" --quiet; then
    echo "Warning: could not fetch origin/$from_branch; using local ref" >&2
  fi

  # Prefer origin/<from> if available, else fall back to local ref.
  local base_ref="origin/$from_branch"
  if ! git rev-parse --verify "$base_ref" &>/dev/null; then
    base_ref="$from_branch"
  fi

  zsh -c 'source ~/.dotfiles/zsh.d/11-git-worktree-functions.zsh && gwt add "$1" "$2"' \
    _ "$branch_name" "$base_ref"
}

main() {
  local command="${1:-}"
  shift || true
  case "$command" in
    create) create_worktree "$@" ;;
    ""|help|-h|--help) usage ;;
    *)
      echo "Error: unknown command '$command'" >&2
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
