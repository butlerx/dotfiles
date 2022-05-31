#!/usr/bin/env zsh

#setopt promptsubst
autoload -U colors && colors # Enable colors in prompt
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "

if [[ -r ${HOME}/.dotfiles/powerlevel9k/powerlevel10k.zsh-theme ]]; then
  # Temporarily change options.
  'builtin' 'local' '-a' 'p10k_config_opts'
  [[ ! -o 'aliases' ]] || p10k_config_opts+=('aliases')
  [[ ! -o 'sh_glob' ]] || p10k_config_opts+=('sh_glob')
  [[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
  'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'
  p10k_config
  # Reenable options
  ((${#p10k_config_opts})) && setopt ${p10k_config_opts[@]}
  'builtin' 'unset' 'p10k_config_opts'
  source "$HOME"/.dotfiles/powerlevel9k/powerlevel10k.zsh-theme
else
  function virtualenv_info() {
    [ "$VIRTUAL_ENV" ] && echo '('"$(basename "$VIRTUAL_ENV")"') '
  }

  function prompt_char() {
    git branch >/dev/null 2>/dev/null && echo '>' && return
    hg root >/dev/null 2>/dev/null && echo '~>' && return
    echo '>'
  }

  function box_name() {
    if [ -f ~/.box-name ]; then
      cat ~/.box-name
    else
      hostname -s
    fi
  }

  # Modify the colors and symbols in these variables as desired.
  export GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
  export GIT_PROMPT_PREFIX="%{$fg[green]%} [%{$reset_color%}"
  export GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
  export GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
  export GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
  export GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
  export GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}u%{$reset_color%}"
  export GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}d%{$reset_color%}"
  export GIT_PROMPT_STAGED="%{$fg_bold[green]%}s%{$reset_color%}"

  # Show Git branch/tag, or name-rev if on detached head
  function parse_git_branch() {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
  }

  # Show different symbols as appropriate for various Git repository states
  function parse_git_state() {

    # Compose this value via multiple conditional appends.
    local GIT_STATE=""
    local NUM_AHEAD=""
    local GIT_DIR=""
    local NUM_BEHIND=""

    NUM_AHEAD="$(git log --oneline @"{u}".. 2>/dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ]; then
      GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
    fi

    NUM_BEHIND="$(git log --oneline ..@"{u}" 2>/dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ]; then
      GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
    fi

    GIT_DIR="$(git rev-parse --git-dir 2>/dev/null)"
    if [ -n "$GIT_DIR" ] && test -r "$GIT_DIR"/MERGE_HEAD; then
      GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
    fi

    if [[ -n $(git ls-files --other --exclude-standard 2>/dev/null) ]]; then
      GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
    fi

    if ! git diff --quiet 2>/dev/null; then
      GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
    fi

    if ! git diff --cached --quiet 2>/dev/null; then
      GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
    fi

    if [[ -n $GIT_STATE ]]; then
      echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
    fi

  }

  # If inside a Git repository, print its branch and state
  function git_prompt_string() {
    local git_where=""
    git_where="$(parse_git_branch)"
    [ -n "$git_where" ] && echo "on %{$fg[blue]%}${git_where#(refs/heads/|tags/)}$(parse_git_state)"
  }

  function current_pwd() {
    pwd | sed -e "s,^$HOME,~,"
  }
  PROMPT="$PR_GREEN%n%{$reset_color%}%{$FG[239]%}@%{$reset_color%}$PR_BOLD_BLUE$(box_name)%{$reset_color%}%{$FG[239]%}: %{$reset_color%}$PR_BOLD_YELLOW$(current_pwd)%{$reset_color%} $(git_prompt_string)%{$reset_color%}$(prompt_char) "
  RPROMPT="$PR_GREEN$(virtualenv_info)%{$reset_color%} $PR_RED$ruby_version%{$reset_color%}"
  export PROMPT
  export RPROMPT
fi
