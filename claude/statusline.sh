#!/usr/bin/env zsh
# pets: symlink=~/.claude/statusline.sh

# Claude Code statusLine script — mirrors Powerlevel10k prompt layout.
# Receives Claude Code JSON on stdin.
#
# Segment order (left to right):
#   os_icon  [context — SSH/root only]  [gwt_worktree]  dir+emoji
#   vcs (branch + dirty/ahead-behind markers)
#   model (robot glyph + name, color 99 lavender)
#   [direnv]
#   [kubecontext]  [terraform]  [aws]  [vpn_ip]
#   [prompt_char — vim mode only]
#
# Segments intentionally omitted (require interactive shell state unavailable here):
#   status, command_execution_time, background_jobs

input=$(cat)

# ── Parse JSON fields ──────────────────────────────────────────────────────────
model=$(echo "$input" | jq -r '.model.display_name // empty' 2>/dev/null)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty' 2>/dev/null)
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty' 2>/dev/null)
worktree_name=$(echo "$input" | jq -r '.worktree.name // empty' 2>/dev/null)

# ── ANSI helpers ───────────────────────────────────────────────────────────────
reset='\033[0m'
bold='\033[1m'
c() { printf '\033[38;5;%sm' "$1"; } # 256-color foreground helper (inline use only)

# p10k dir: POWERLEVEL9K_DIR_FOREGROUND=31, POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39, ANCHOR_BOLD=true
dir_color='\033[38;5;31m'  # 256-color 31 — steel blue (shortened/mid segments)
dir_anchor='\033[38;5;39m' # 256-color 39 — bright cyan-blue (last/anchor segment, bold)

# p10k context (SSH/root): POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=180
context_color='\033[38;5;180m' # 256-color 180 — warm tan/gold

# vcs colors from my_git_formatter in p10k config
git_clean='\033[38;5;76m'     # clean: 76 chartreuse (POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76)
git_modified='\033[38;5;178m' # modified/staged: 178 yellow (POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178)
git_untracked='\033[38;5;39m' # untracked: 39 bright cyan (from my_git_formatter)
git_conflict='\033[38;5;196m' # conflicted: 196 red

# gwt_worktree: `p10k segment -f cyan`
worktree_color='\033[36m'

# Right-prompt segment colors (from p10k config)
direnv_color='\033[38;5;178m' # POWERLEVEL9K_DIRENV_FOREGROUND=178
kube_color='\033[38;5;134m'   # POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=134 (medium purple)
tf_color='\033[38;5;38m'      # POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND=38 (dark cyan)
aws_color='\033[38;5;208m'    # POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=208 (orange)
vpn_color='\033[38;5;81m'     # POWERLEVEL9K_VPN_IP_FOREGROUND=81 (sky blue)
model_color='\033[38;5;99m'   # model: bright lavender (distinct, fits blue/green palette)

# p10k prompt_char OK: POWERLEVEL9K_PROMPT_CHAR_OK_*_FOREGROUND=76
vi_green='\033[38;5;76m' # 256-color 76

# Working directory used for git and project-root detection
git_dir="${cwd:-$PWD}"

# ── Segment 1: os_icon ────────────────────────────────────────────────────────
# POWERLEVEL9K_OS_ICON_FOREGROUND= (unset → default terminal color)
os_segment=" "

# ── Segment 2: context — user@hostname, SSH or root only ─────────────────────
# POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_*_EXPANSION= (hidden locally; shown on SSH/root)
context_segment=""
if [ -n "$SSH_CONNECTION" ] || [ "$(id -u)" -eq 0 ]; then
  context_segment="${context_color}$(whoami)@$(hostname -s)${reset} "
fi

# ── Resolve cwd with $HOME → ~ ────────────────────────────────────────────────
if [ -n "$cwd" ]; then
  home="$HOME"
  resolved_dir="${cwd/#$home/~}"
else
  resolved_dir="$(pwd | sed "s|^$HOME|~|")"
fi

# ── Segment 3: gwt_worktree ───────────────────────────────────────────────────
gwt_segment=""
case "$resolved_dir" in
*.worktrees/*)
  if [ -n "$worktree_name" ]; then
    repo_name=$(echo "$input" | jq -r '.workspace.repo.name // empty' 2>/dev/null)
    [ -z "$repo_name" ] && repo_name=$(basename "$(echo "$input" | jq -r '.workspace.project_dir // empty' 2>/dev/null)" 2>/dev/null)
    [ -n "$repo_name" ] && gwt_segment="${worktree_color}🌿 ${repo_name} ⟫ ${worktree_name}${reset} "
  fi
  if [ -z "$gwt_segment" ]; then
    wt_base="${resolved_dir%%.worktrees/*}"
    repo_part="${wt_base##*/}"
    repo_part="${repo_part%.}"
    after_wt="${resolved_dir#*.worktrees/}"
    slug="${after_wt%%/*}"
    [ -n "$slug" ] && gwt_segment="${worktree_color}🌿 ${repo_part} ⟫ ${slug}${reset} "
  fi
  ;;
esac

# ── Segment 4: dir + emoji ────────────────────────────────────────────────────
display_dir="$resolved_dir"
dir_emoji=""

case "$display_dir" in
*.worktrees/*)
  dir_emoji="🚀"
  subpath="${display_dir#*.worktrees/}"
  subpath="${subpath#*/}"
  display_dir="$subpath"
  ;;
~/projects/ihs/* | ~/projects/cloudsmith-io/* | ~/projects/evervault/*)
  dir_emoji="🚀"
  ;;
~/*)
  dir_emoji="⌂"
  ;;
esac

dir_head="${display_dir%/*}"
dir_tail="${display_dir##*/}"

if [ -z "$display_dir" ]; then
  dir_segment=""
elif [ "$dir_head" = "$dir_tail" ] || [ -z "$dir_head" ]; then
  dir_segment="${dir_emoji:+${dir_emoji} }${bold}${dir_anchor}${display_dir}${reset}"
else
  dir_segment="${dir_emoji:+${dir_emoji} }${dir_color}${dir_head}/${reset}${bold}${dir_anchor}${dir_tail}${reset}"
fi

# ── Segment 5: vcs — branch + full dirty/ahead-behind markers ────────────────
# Single `git status --porcelain=v2 --branch` call for efficiency.
# Colors match my_git_formatter in p10k config:
#   clean=76 chartreuse, modified/staged=178 yellow, untracked=39 cyan, conflicted=196 red
git_segment=""
if command -v git >/dev/null 2>&1; then
  git_raw=$(git -C "$git_dir" status --porcelain=v2 --branch 2>/dev/null)
  if [ -n "$git_raw" ]; then
    branch=$(printf '%s\n' "$git_raw" | awk '/^# branch.head / {print $3}')
    ab_line=$(printf '%s\n' "$git_raw" | awk '/^# branch.ab / {print $3, $4}')
    ahead=0
    behind=0
    if [ -n "$ab_line" ]; then
      ahead=$(printf '%s\n' "$ab_line" | awk '{v=$1; gsub(/[^0-9]/,"",v); print v+0}')
      behind=$(printf '%s\n' "$ab_line" | awk '{v=$2; gsub(/[^0-9]/,"",v); print v+0}')
    fi

    staged=0
    unstaged=0
    untracked=0
    conflicted=0
    while IFS= read -r line; do
      case "$line" in
      'u '*)
        conflicted=$((conflicted + 1))
        ;;
      '? '*)
        untracked=$((untracked + 1))
        ;;
      '1 '*)
        xy="${line#1 }"
        xy="${xy%% *}"
        x="${xy%?}"
        y="${xy#?}"
        [ "$x" != "." ] && staged=$((staged + 1))
        [ "$y" != "." ] && unstaged=$((unstaged + 1))
        ;;
      '2 '*)
        xy="${line#2 }"
        xy="${xy%% *}"
        x="${xy%?}"
        y="${xy#?}"
        [ "$x" != "." ] && staged=$((staged + 1))
        [ "$y" != "." ] && unstaged=$((unstaged + 1))
        ;;
      esac
    done <<GIT_STATUS_EOF
$(printf '%s\n' "$git_raw" | grep -v '^# ')
GIT_STATUS_EOF

    stashes=0
    _git_toplevel=$(git -C "$git_dir" rev-parse --show-toplevel 2>/dev/null)
    if [ -f "${_git_toplevel}/.git/refs/stash" ]; then
      stashes=$(wc -l <"${_git_toplevel}/.git/refs/stash" 2>/dev/null | tr -d ' ')
    fi

    if [ "$staged" -gt 0 ] || [ "$unstaged" -gt 0 ]; then
      branch_color="$git_modified"
    elif [ "$untracked" -gt 0 ]; then
      branch_color="$git_untracked"
    elif [ "$conflicted" -gt 0 ]; then
      branch_color="$git_conflict"
    else
      branch_color="$git_clean"
    fi

    if [ "$branch" = "(detached)" ]; then
      commit=$(git -C "$git_dir" rev-parse --short HEAD 2>/dev/null)
      branch_text="@${commit}"
    elif [ "${#branch}" -gt 32 ]; then
      branch_text="${branch:0:12}…${branch: -12}"
    else
      branch_text="$branch"
    fi

    gs="${branch_color} ${branch_text}${reset}"
    [ "$behind" -gt 0 ] && gs="${gs} ${git_clean}⇣${behind}${reset}"
    [ "$ahead" -gt 0 ] && gs="${gs} ${git_clean}⇡${ahead}${reset}"
    [ "$stashes" -gt 0 ] && gs="${gs} ${git_clean}*${stashes}${reset}"
    [ "$conflicted" -gt 0 ] && gs="${gs} ${git_conflict}~${conflicted}${reset}"
    [ "$staged" -gt 0 ] && gs="${gs} ${git_modified}+${staged}${reset}"
    [ "$unstaged" -gt 0 ] && gs="${gs} ${git_modified}!${unstaged}${reset}"
    [ "$untracked" -gt 0 ] && gs="${gs} ${git_untracked}?${untracked}${reset}"

    git_segment=" ${gs}"
  fi
fi
#" ${git_color} ${branch}${reset}"  #  = Powerline branch glyph

# ── Segment 6: Claude model — Nerd Font robot face (U+F09A), color 99 lavender ──────────────
# Color 99 = bright lavender (distinct from env-tool segments).
model_segment=""
if [ -n "$model" ]; then
  model_segment=" ${model_color} ${model}${reset}"
fi

# ── Segment 7: direnv ────────────────────────────────────────────────────────
# POWERLEVEL9K_DIRENV_FOREGROUND=178. Show when $DIRENV_DIR is set.
direnv_segment=""
if [ -n "$DIRENV_DIR" ]; then
  direnv_segment=" ${direnv_color} direnv${reset}"
fi

# ── Segment 8: kubecontext ───────────────────────────────────────────────────
# POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=134.
# kubectl config current-context reads kubeconfig file only — no API call.
kube_segment=""
if command -v kubectl >/dev/null 2>&1; then
  kube_ctx=$(kubectl config current-context 2>/dev/null)
  if [ -n "$kube_ctx" ]; then
    kube_ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    kube_display="$kube_ctx"
    [ -n "$kube_ns" ] && [ "$kube_ns" != "default" ] && kube_display="${kube_ctx}:${kube_ns}"
    kube_segment=" ${kube_color}󱃾 ${kube_display}${reset}"
  fi
fi

# ── Segment 9: terraform workspace ───────────────────────────────────────────
# POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND=38, POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT=false.
# Reads .terraform/environment — no terraform binary call needed.
tf_segment=""
_check_dir="$git_dir"
while [ "$_check_dir" != "/" ] && [ "$_check_dir" != "$HOME" ]; do
  if [ -d "${_check_dir}/.terraform" ]; then
    tf_ws="default"
    [ -f "${_check_dir}/.terraform/environment" ] && tf_ws=$(cat "${_check_dir}/.terraform/environment" 2>/dev/null)
    [ -z "$tf_ws" ] && tf_ws="default"
    if [ "$tf_ws" != "default" ]; then
      tf_segment=" ${tf_color} ${tf_ws}${reset}"
    fi
    break
  fi
  _check_dir=$(dirname "$_check_dir")
done

# ── Segment 10: aws ──────────────────────────────────────────────────────────
# POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=208.
# $AWS_VAULT takes precedence (set by aws-vault exec subshell), then $AWS_PROFILE.
aws_segment=""
aws_prof="${AWS_VAULT:-$AWS_PROFILE}"
if [ -n "$aws_prof" ]; then
  aws_display="$aws_prof"
  [ -n "$AWS_DEFAULT_REGION" ] && aws_display="${aws_prof} ${AWS_DEFAULT_REGION}"
  aws_segment=" ${aws_color} ${aws_display}${reset}"
fi

# ── Segment 11: vpn_ip ───────────────────────────────────────────────────────
# POWERLEVEL9K_VPN_IP_FOREGROUND=81. p10k shows icon only (CONTENT_EXPANSION= is empty).
# Interface pattern from config: (gpd|wg|(.*tun)|tailscale)[0-9]*
vpn_segment=""
if command -v ifconfig >/dev/null 2>&1; then
  vpn_iface=$(ifconfig 2>/dev/null | awk '/^(gpd|wg|tun|tailscale)[0-9]/{gsub(/:$/,"",$1); print $1; exit}')
  [ -n "$vpn_iface" ] && vpn_segment=" ${vpn_color}󰦝${reset}"
fi

# ── Segment 12: prompt_char — vim mode only ──────────────────────────────────
# POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
# VIINS -> ❯  VICMD/NORMAL -> ❮  VIVIS -> V  VIOWR -> ▶
vim_segment=""
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
  NORMAL) vim_symbol="❮" ;;
  INSERT) vim_symbol="❯" ;;
  VISUAL) vim_symbol="V" ;;
  "VISUAL LINE") vim_symbol="VL" ;;
  OVERWRITE) vim_symbol="▶" ;;
  *) vim_symbol="$vim_mode" ;;
  esac
  vim_segment=" ${bold}${vi_green}${vim_symbol}${reset}"
fi

# ── Assemble ──────────────────────────────────────────────────────────────────
# os_icon  [context]  [gwt_worktree]  dir  vcs  model
# [direnv]  [kube]  [terraform]  [aws]  [vpn]  [vim]
printf "%b%b%b%b%b%b%b%b%b%b%b%b\n" \
  "$os_segment" \
  "$context_segment" \
  "$gwt_segment" \
  "$dir_segment" \
  "$git_segment" \
  "$model_segment" \
  "$direnv_segment" \
  "$kube_segment" \
  "$tf_segment" \
  "$aws_segment" \
  "$vpn_segment" \
  "$vim_segment"
