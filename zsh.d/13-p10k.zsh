#!/usr/bin/env zsh

p10k_config() {
  emulate -L zsh -o extended_glob
  setopt no_unset
  local LC_ALL=C.UTF-8

  # Unset all configuration options. Allows applying changes without restarting zsh.
  unset -m 'POWERLEVEL9K_*'

  # Zsh >= 5.1 is required.
  autoload -Uz is-at-least && is-at-least 5.1 || return

  # Prompt layout — left has the most important segments, right auto-hides when input reaches it.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon                 # os identifier
    context                 # user@hostname
    dir                     # current directory
    prompt_char             # prompt symbol
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    vcs                     # git status
    background_jobs         # presence of background jobs
    direnv                  # direnv status (https://direnv.net/)
    mise                    # mise tool versions (https://mise.jdx.dev/)
    virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
    pyenv                   # python environment (https://github.com/pyenv/pyenv)
    nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
    node_version            # node.js version
    go_version              # go version (https://golang.org)
    rust_version            # rustc version (https://www.rust-lang.org)
    kubecontext             # current kubernetes context (https://kubernetes.io/)
    terraform               # terraform workspace (https://www.terraform.io)
    aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
    vim_shell               # vim shell indicator (:sh)
    vpn_ip                  # virtual private network indicator
  )

  if (( $+commands[playerctl] )); then
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=(custom_playerctl_status)
  fi

  # Character set. Best set by `p10k configure`.
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  # When 'moderate', adds extra space after some icons to avoid overlap with non-monospace fonts.
  typeset -g POWERLEVEL9K_ICON_PADDING=none
  # Icons appear before content on both sides of the prompt.
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true

  # Transparent background, no surrounding whitespace, space-separated segments.
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=

  # No empty line before each prompt.
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
  # No horizontal ruler line before each prompt.
  typeset -g POWERLEVEL9K_SHOW_RULER=false
  # Filler between left and right prompt on the first line. Space = invisible.
  # Change to '·' or '─' to visually separate prompt from command output.
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '

  # Multiline connectors (all empty — single-line style)
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  # Transient prompt: trim down previous prompts when accepting a command line.
  # Options: off, always, same-dir (only trims if still in same directory).
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  # Instant prompt: render prompt immediately on startup before zsh finishes initializing.
  # Options: off, quiet (suppress warnings), verbose (show warnings during init).
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # Hot reload can slow prompt by 1-2ms. Keep off unless actively tweaking config.
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
  typeset -g DEFAULT_USER="$USER"

  ##################################[ os_icon: os identifier ]##################################
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=

  ################################[ prompt_char: prompt symbol ]################################
  # Green prompt symbol on success.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
  # Red prompt symbol on error.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
  # Prompt symbols for each vi mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  # No line terminator/introducer when prompt_char is the last/first segment.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=

  ##################################[ dir: current directory ]##################################
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
  # Shorten directory segments to the shortest possible unique prefix (tab-completable).
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  # Symbol replacing removed segment suffixes.
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  # Color of shortened segments.
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103
  # Color of anchor segments (never shortened, first segment is always an anchor).
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  # Directories containing these files are never shortened (they are anchors).
  local anchor_files=(
    .bzr .citc .git .hg .svn .terraform CVS
    .node-version .python-version .go-version .ruby-version
    .lua-version .java-version .perl-version .php-version .tool-version
    .mise .mise.toml mise.toml .shorten_folder_marker
    Cargo.toml composer.json go.mod package.json stack.yaml
  )
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
  # Don't remove segments before the first marker directory.
  # Options: false, "first", "last", "first:<offset>", "last:<offset>".
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  # Always keep at least this many trailing directory segments.
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  # Shorten directory if longer than this (absolute chars or percentage like '50%').
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  # When dir is on the last prompt line, shorten to leave this many columns for typing.
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  # Embed a hyperlink into the directory (click to open in file manager).
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  # Enable special styling for non-writable and non-existent directories (v3 adds lock icon).
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

  # Custom directory classes: pattern → class → icon.
  # Classes get _NOT_WRITABLE / _NON_EXISTENT suffixes automatically (SHOW_WRITABLE=v3).
  # Styling per class: POWERLEVEL9K_DIR_{CLASS}_FOREGROUND, etc.
  typeset -g POWERLEVEL9K_DIR_CLASSES=(
    '~/projects/(ihs|cloudsmith-io|evervault)(/*)#'  WORK     '(╯°□°）╯︵ ┻━┻'
    '~(/*)#'                                         HOME     '⌂'
    '*'                                              DEFAULT  '')

  #####################################[ vcs: git status ]######################################
  # Branch icon. '\uF126 ' = Powerline branch icon.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  # Custom Git status formatter.
  # Output format: master wip ⇣42⇡42 *42 merge ~42 +42 !42 ?42
  # VCS_STATUS_* parameters are set by gitstatus plugin. See reference:
  # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh
  my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      # P9K_CONTENT is "loading" or from vcs_info (not gitstatus). Use as-is.
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    if (( $1 )); then
      # Styling for up-to-date Git status.
      local       meta='%f'      # default foreground
      local      clean='%76F'    # green
      local   modified='%178F'   # yellow
      local  untracked='%39F'    # blue
      local conflicted='%196F'   # red
    else
      # Styling for incomplete/stale Git status.
      local       meta='%244F'   # grey
      local      clean='%244F'
      local   modified='%244F'
      local  untracked='%244F'
      local conflicted='%244F'
    fi

    local res

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      # Truncate branch names longer than 32 chars: first 12 … last 12.
      (( $#branch > 32 )) && branch[13,-13]="…"
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    # Show tag only when not on a branch.
    if [[ -n $VCS_STATUS_TAG && -z $VCS_STATUS_LOCAL_BRANCH ]]; then
      local tag=${(V)VCS_STATUS_TAG}
      (( $#tag > 32 )) && tag[13,-13]="…"
      res+="${meta}#${clean}${tag//\%/%%}"
    fi

    # Show commit hash when there's no branch and no tag (detached HEAD).
    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&
      res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

    # Show tracking branch name if it differs from local branch.
    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
    fi

    # Show "wip" if the latest commit summary contains "wip" or "WIP".
    if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
      res+=" ${modified}wip"
    fi

    # ⇣42 behind remote, ⇡42 ahead of remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
    # ⇠42 behind push remote, ⇢42 ahead of push remote.
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
    # *42 stashes, ~42 merge conflicts, +42 staged, !42 unstaged, ?42 untracked.
    (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    # "─" if the number of unstaged files is unknown (due to MAX_INDEX_SIZE_DIRTY
    # or bash.showDirtyState=false). Staged/untracked counts may also be unknown.
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

    typeset -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  # Don't limit dirty file counting. Negative = infinity.
  # If you have repos with millions of files and see slowness, set this lower
  # than `git ls-files | wc -l`, or set `git config bash.showDirtyState false`.
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  # Don't show Git status in $HOME (the dotfiles repo).
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
  # Use custom formatter instead of default gitstatus formatting.
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  # Don't limit counters for staged, unstaged, etc.
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=76
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=244
  # Only use git (not svn/hg) — adding others can slow prompt even outside those repos.
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  # Fallback colors when gitstatus is unavailable and vcs_info is used instead.
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=76
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178

  ##########################[ status: exit code of the last command ]###########################
  # Enable OK_PIPE, ERROR_PIPE, ERROR_SIGNAL states for independent styling.
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  # Don't show status on success (prompt_char already turns green).
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=70
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
  # Show when part of a pipe fails but overall exit is zero (e.g. 1|0).
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=70
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'
  # Don't show plain error codes (prompt_char already turns red).
  typeset -g POWERLEVEL9K_STATUS_ERROR=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=160
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
  # Show when last command was killed by a signal.
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=160
  # Use terse signal names: "INT" instead of "SIGINT(2)".
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'
  # Show when pipe fails and overall exit is non-zero (e.g. 1|0).
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=160
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'

  ###################[ command_execution_time: duration of the last command ]###################
  # Only show when the last command took longer than this many seconds.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  # Round to whole seconds (0 = no fractional digits).
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=101
  # Human-readable format: 1d 2h 3m 4s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  #######################[ background_jobs: presence of background jobs ]#######################
  # Don't show the count, just the icon.
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=70

  ##################################[ context: user@hostname ]##################################
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=178       # running as root
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=180  # SSH
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=180             # default (local, no root)
  # Format: bold user@hostname for root, plain user@hostname otherwise.
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%B%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  # Hide context unless running with privileges or in SSH.
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

  #######################[ direnv: direnv status (https://direnv.net/) ]########################
  typeset -g POWERLEVEL9K_DIRENV_FOREGROUND=178

  ###############[ mise: mise tool versions (https://mise.jdx.dev/) ]###############
  typeset -g POWERLEVEL9K_MISE_FOREGROUND=66
  # Sources: shell (env var), local (.mise.toml up the tree), global (~/.config/mise/config.toml).
  typeset -g POWERLEVEL9K_MISE_SOURCES=(shell local global)
  # Hide version if it matches global. Override per-tool: POWERLEVEL9K_MISE_${TOOL}_PROMPT_ALWAYS_SHOW.
  typeset -g POWERLEVEL9K_MISE_PROMPT_ALWAYS_SHOW=false
  # Show tools with version "system".
  typeset -g POWERLEVEL9K_MISE_SHOW_SYSTEM=true
  # Hide tools unless a matching file exists up the tree. Override per-tool: POWERLEVEL9K_MISE_${TOOL}_SHOW_ON_UPGLOB.
  typeset -g POWERLEVEL9K_MISE_SHOW_ON_UPGLOB=
  # Per-tool colors.
  typeset -g POWERLEVEL9K_MISE_RUBY_FOREGROUND=168
  typeset -g POWERLEVEL9K_MISE_PYTHON_FOREGROUND=37
  typeset -g POWERLEVEL9K_MISE_GOLANG_FOREGROUND=37
  typeset -g POWERLEVEL9K_MISE_NODEJS_FOREGROUND=70
  typeset -g POWERLEVEL9K_MISE_RUST_FOREGROUND=37
  typeset -g POWERLEVEL9K_MISE_DOTNET_CORE_FOREGROUND=134
  typeset -g POWERLEVEL9K_MISE_FLUTTER_FOREGROUND=38
  typeset -g POWERLEVEL9K_MISE_LUA_FOREGROUND=32
  typeset -g POWERLEVEL9K_MISE_JAVA_FOREGROUND=32
  typeset -g POWERLEVEL9K_MISE_PERL_FOREGROUND=67
  typeset -g POWERLEVEL9K_MISE_ERLANG_FOREGROUND=125
  typeset -g POWERLEVEL9K_MISE_ELIXIR_FOREGROUND=129
  typeset -g POWERLEVEL9K_MISE_POSTGRES_FOREGROUND=31
  typeset -g POWERLEVEL9K_MISE_PHP_FOREGROUND=99
  typeset -g POWERLEVEL9K_MISE_HASKELL_FOREGROUND=172
  typeset -g POWERLEVEL9K_MISE_JULIA_FOREGROUND=70

  ###[ virtualenv: python virtual environment (https://docs.python.org/3/library/venv.html) ]###
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=37
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  # Don't show virtualenv if pyenv is already showing the same info.
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  ################[ pyenv: python environment (https://github.com/pyenv/pyenv) ]################
  typeset -g POWERLEVEL9K_PYENV_FOREGROUND=37
  typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=true
  # Show python version alongside pyenv env name when they differ.
  typeset -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_CONTENT:#$P9K_PYENV_PYTHON_VERSION(|/*)}:+ $P9K_PYENV_PYTHON_VERSION}'

  ##############[ nvm: node.js version from nvm (https://github.com/nvm-sh/nvm) ]###############
  typeset -g POWERLEVEL9K_NVM_FOREGROUND=70

  ##############################[ node_version: node.js version ]###############################
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=70
  # Only show when in a directory tree containing package.json.
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true

  #######################[ go_version: go version (https://golang.org) ]########################
  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=37
  # Only show in a go project subdirectory.
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true

  #################[ rust_version: rustc version (https://www.rust-lang.org) ]##################
  typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=37
  typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true

  #############[ kubecontext: current kubernetes context (https://kubernetes.io/) ]#############
  # Classes: pattern → class. First match wins.
  # Style per-class: POWERLEVEL9K_KUBECONTEXT_{CLASS}_FOREGROUND, _CONTENT_EXPANSION, etc.
  typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
    '*'                      DEFAULT)
  typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_FOREGROUND=28
  typeset -g POWERLEVEL9K_KUBECONTEXT_TEST_CONTENT_EXPANSION='> ${P9K_CONTENT} <'
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=134
  # Show cloud cluster name if available, otherwise context name.
  # Available params: P9K_KUBECONTEXT_{NAME,CLUSTER,NAMESPACE,USER}
  # For GKE/EKS: P9K_KUBECONTEXT_CLOUD_{NAME,ACCOUNT,ZONE,CLUSTER}
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION=
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}'

  ################[ terraform: terraform workspace (https://www.terraform.io) ]#################
  # Don't show the "default" workspace.
  typeset -g POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT=false
  typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=(
    '*'  OTHER)
  typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND=38

  #[ aws: aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) ]#
  # Show when typing AWS-related commands, or always when inside an aws-vault exec subshell.
  typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|aws-vault|awless|terraform|tf|pulumi|terragrunt|mise'
  typeset -g POWERLEVEL9K_AWS_CLASSES=(
    '*'  DEFAULT)
  typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=208
  # Show profile and region. Available params: P9K_AWS_PROFILE, P9K_AWS_REGION.
  typeset -g POWERLEVEL9K_AWS_CONTENT_EXPANSION='${P9K_AWS_PROFILE//\%/%%}${P9K_AWS_REGION:+ ${P9K_AWS_REGION//\%/%%}}'

  ###########################[ vim_shell: vim shell indicator (:sh) ]###########################
  typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=34

  ########################[ vpn_ip: virtual private network indicator ]#########################
  typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=81
  # Show just the icon, no IP address.
  typeset -g POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION=
  # Regex for VPN network interface names. Check `ifconfig` or `ip -4 a show` while on VPN.
  typeset -g POWERLEVEL9K_VPN_IP_INTERFACE='(gpd|wg|(.*tun)|tailscale)[0-9]*'
  # Show only one segment for the first matching interface (not one per interface).
  typeset -g POWERLEVEL9K_VPN_IP_SHOW_ALL=false

  #############################[ playerctl (custom segment) ]############################
  typeset -g POWERLEVEL9K_CUSTOM_PLAYERCTL='playerctl_status'
  typeset -g POWERLEVEL9K_CUSTOM_PLAYERCTL_FOREGROUND='white'
  typeset -g POWERLEVEL9K_CUSTOM_PLAYERCTL_BACKGROUND='black'
  playerctl_status() {
    local state
    state=$(playerctl status 2>/dev/null) || return
    if [[ "$state" == "Playing" ]]; then
      echo -n "$(playerctl metadata artist) - $(playerctl metadata title)"
    fi
  }

  # Reload configuration if p10k is already loaded.
  (( ! $+functions[p10k] )) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}
