POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context vi_mode dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vcs nvm)
POWERLEVEL9K_STATUS_VERBOSE=false
export DEFAULT_USER=$USER
export AWS_DEFAULT_PROFILE='cianbuterx@gmail.com'
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
