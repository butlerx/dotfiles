---
name: ce-worktree
description: Create an isolated git worktree for parallel feature work or PR review. Use when starting work that should not disturb the current checkout, or when `ce-work` or `ce-code-review` offers a worktree option.
---

# Worktree Creation

Create a worktree at `../<repo>.worktrees/<branch>` (beside the repo, slashes in the branch become dashes) using the user's `gwt` shell functions, which handle setup that `git worktree add` alone does not:

- Generates `.envrc.gwt` (loads `.env` and the Python venv from the main checkout, isolates `CARGO_TARGET_DIR`)
- Copies the main checkout's `.envrc` (or creates one) and runs `direnv allow`
- Symlinks `node_modules`, `.venv` and `vendor` from the main checkout
- Does not modify the main repo checkout — `from-branch` is fetched, not checked out

## Creating a worktree

```bash
bash scripts/worktree-manager.sh create <branch-name> [from-branch]
```

Defaults:
- `from-branch` defaults to origin's default branch (or `main` if that cannot be resolved)
- The new branch is created at `origin/<from-branch>` (or the local ref if the remote is unavailable)

Examples:
```bash
bash scripts/worktree-manager.sh create feat/login
bash scripts/worktree-manager.sh create fix/email-validation develop
```

The script prints the worktree path. Switch with `cd` to that path.

## Other worktree operations

`gwt` is a zsh function, so call it through zsh:

```bash
zsh -c 'source ~/.dotfiles/zsh.d/11-git-worktree-functions.zsh && gwt list'           # list worktrees
zsh -c 'source ~/.dotfiles/zsh.d/11-git-worktree-functions.zsh && gwt status'         # changes per worktree
git worktree remove "$(git worktree list --porcelain | awk 'NR==1{print $2}').worktrees/<branch-with-dashes>"  # remove a worktree
```

Avoid `gwt rm` from an agent: it prompts interactively when the worktree has uncommitted changes.

## Dev tool trust behavior

gwt replaces the worktree's `.envrc` with the main checkout's copy and then runs `direnv allow` on every branch, including PR review branches. The `.envrc` itself comes from main, but anything it sources or evaluates (`source_env` scripts, `use flake`, `.env` in the worktree) comes from the branch. Treat a review worktree's environment as untrusted code. `mise trust` is not run; if mise prompts, review the branch's mise config before trusting it.

## When to create a worktree

Create a worktree when:
- Reviewing a PR while keeping the main checkout free for other work
- Running multiple features in parallel without branch-switching overhead
- Keeping the default branch free of in-progress state

Do not create a worktree for single-task work that can happen on a branch in the main checkout.

## Integration

`ce-work` and `ce-code-review` offer this skill as an option. When the user selects "worktree" in those flows, invoke `bash scripts/worktree-manager.sh create <branch>` with a meaningful branch name derived from the work description (e.g., `feat/crowd-sniff`, `fix/email-validation`). Avoid auto-generated names like `worktree-jolly-beaming-raven` that obscure the work.

## Troubleshooting

**"Worktree already exists"**: the path is already in use. Either `cd` to it or remove it with `git worktree remove <path>` before recreating.

**"Cannot remove worktree: it is the current worktree"**: `cd` out of the worktree first, then `git worktree remove`.

**direnv shows the main checkout's environment**: expected. gwt copies the main `.envrc`. Review the branch's `.envrc` with `git diff <base-ref> -- .envrc` before restoring it with `git checkout -- .envrc` and running `direnv allow`.
