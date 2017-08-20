#setopt promptsubst
autoload -U colors && colors # Enable colors in prompt
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "

if [[ -r ${HOME}/.dotfiles/powerlevel9k/powerlevel9k.zsh-theme ]]; then
  source ${HOME}/.dotfiles/powerlevel9k/powerlevel9k.zsh-theme
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context vi_mode dir)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vcs)
  #POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vcs custom_playerctl_status)
  POWERLEVEL9K_STATUS_VERBOSE=false
  POWERLEVEL9K_MODE='awesome-fontconfig'
  export DEFAULT_USER=$USER
  export AWS_DEFAULT_PROFILE='cianbutlerx@gmail.com'
  export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "

  #nvm
  POWERLEVEL9K_NVM_BACKGROUND='28'
  POWERLEVEL9K_NVM_FOREGROUND='15'

  # Directory
  POWERLEVEL9K_DIR_PATH_SEPARATOR=$' \uE0B1 '
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_DIR_HOME_BACKGROUND="238"
  POWERLEVEL9K_DIR_HOME_FOREGROUND="255"
  POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="238"
  POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="255"
  POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="238"
  POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="255"

  # Git
  POWERLEVEL9K_VCS_STAGED_ICON=$'\u00b1'
  POWERLEVEL9K_VCS_UNTRACKED_ICON=$'\u25CF'
  POWERLEVEL9K_VCS_UNSTAGED_ICON=$'\u00b1'
  POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=$'\u2193'
  POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=$'\u2191'
  POWERLEVEL9K_VCS_CLEAN_FOREGROUND='white'
  POWERLEVEL9K_VCS_CLEAN_BACKGROUND='black'
  POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='124'
  POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
  POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='190'
  POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'

  # Vi-Mode
  POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND='076'
  POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='236'
  POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND='231'
  POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND='000'

  function zle-line-init {
    powerlevel9k_prepare_prompts
    if (( ${+terminfo[smkx]} )); then
      printf '%s' ${terminfo[smkx]}
    fi
    zle reset-prompt
    zle -R
  }
  function zle-line-finish {
    powerlevel9k_prepare_prompts
    if (( ${+terminfo[rmkx]} )); then
      printf '%s' ${terminfo[rmkx]}
    fi
    zle reset-prompt
    zle -R
  }
  function zle-keymap-select {
    powerlevel9k_prepare_prompts
    zle reset-prompt
    zle -R
  }
  zle -N zle-line-init
  zle -N ale-line-finish
  zle -N zle-keymap-select

  # Playerctl
  POWERLEVEL9K_CUSTOM_PLAYERCTL='playerctl_status'
  POWERLEVEL9K_CUSTOM_PLAYERCTL_FOREGROUND='white'
  POWERLEVEL9K_CUSTOM_PLAYERCTL_BACKGROUND='black'
  playerctl_status () {
    state=$(playerctl status);
    if [ $state != "Playing" ]; then
    else
      artist=$(playerctl metadata artist)
      track=$(playerctl metadata title)
      echo -n "$artist - $track";
    fi
  }
else
  function virtualenv_info {
      [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
  }

  function prompt_char {
      git branch >/dev/null 2>/dev/null && echo '>' && return
      hg root >/dev/null 2>/dev/null && echo '~>'&& return
      echo '>'
  }

  function box_name {
      [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
  }

  # Modify the colors and symbols in these variables as desired.
  GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
  GIT_PROMPT_PREFIX="%{$fg[green]%} [%{$reset_color%}"
  GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
  GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
  GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
  GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
  GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}u%{$reset_color%}"
  GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}d%{$reset_color%}"
  GIT_PROMPT_STAGED="%{$fg_bold[green]%}s%{$reset_color%}"

  # Show Git branch/tag, or name-rev if on detached head
  function parse_git_branch() {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
  }

  # Show different symbols as appropriate for various Git repository states
  function parse_git_state() {

    # Compose this value via multiple conditional appends.
    local GIT_STATE=""

    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ]; then
      GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
    fi

    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ]; then
      GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
    fi

    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
      GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
    fi

    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
      GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
    fi

    if ! git diff --quiet 2> /dev/null; then
      GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
      GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
    fi

    if [[ -n $GIT_STATE ]]; then
      echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
    fi

  }


  # If inside a Git repository, print its branch and state
  function git_prompt_string() {
    local git_where="$(parse_git_branch)"
    [ -n "$git_where" ] && echo "on %{$fg[blue]%}${git_where#(refs/heads/|tags/)}$(parse_git_state)"
  }

  # determine Ruby version whether using RVM or rbenv
  # the chpwd_functions line cause this to update only when the directory changes
  function _update_ruby_version() {
      typeset -g ruby_version=''
      if which rvm-prompt &> /dev/null; then
        ruby_version="$(rvm-prompt i v g)"
      else
        if which rbenv &> /dev/null; then
          ruby_version="$(rbenv version | sed -e "s/ (set.*$//")"
        fi
      fi
  }
  chpwd_functions+=(_update_ruby_version)

  function current_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
  }
  PROMPT='${PR_GREEN}%n%{$reset_color%}%{$FG[239]%}@%{$reset_color%}${PR_BOLD_BLUE}$(box_name)%{$reset_color%}%{$FG[239]%}: %{$reset_color%}${PR_BOLD_YELLOW}$(current_pwd)%{$reset_color%} $(git_prompt_string)%{$reset_color%}$(prompt_char) '
  RPROMPT='${PR_GREEN}$(virtualenv_info)%{$reset_color%} ${PR_RED}${ruby_version}%{$reset_color%}'
fi
