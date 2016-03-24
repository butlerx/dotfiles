# -------------------------------------------------------------------
# use nocorrect alias to prevent auto correct from "fixing" these
# -------------------------------------------------------------------
alias foobar='nocorrect foobar'
alias g8='nocorrect g8'

# -------------------------------------------------------------------
# Ruby stuff
# -------------------------------------------------------------------
alias ri='ri -Tf ansi' # Search Ruby documentation
alias rake="noglob rake" # necessary to make rake work inside of zsh
alias be='bundle exec'
alias bx='bundle exec'
alias gentags='ctags .'

# -------------------------------------------------------------------
# directory movement
# -------------------------------------------------------------------

alias cd~='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias bk='cd $OLDPWD'

# -------------------------------------------------------------------
# directory information
# -------------------------------------------------------------------
alias lh='ls -d .*' # show hidden files/directories only
alias lsd='ls -aFhlG'
alias l='ls -al'
alias ls='ls -GFh' # Colorize output, add file type indicator, and put sizes in human readable format
alias ll='ls -GFhl' # Same as above, but in long listing format
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias dus='du -sckx * | sort -nr' #directories sorted by size

alias wordy='wc -w * | sort | tail -n10' # sort files in current directory by the number of words they contain
alias filecount='find . -type f | wc -l' # number of files (not directories)

# -------------------------------------------------------------------
# Mac only
# -------------------------------------------------------------------
if [[ $IS_MAC -eq 1 ]]; then
    alias ql='qlmanage -p 2>/dev/null' # OS X Quick Look
    alias oo='open .' # open current directory in OS X Finder
    alias today='calendar -A 0 -f /usr/share/calendar/calendar.mark | sort'
    alias mailsize='du -hs ~/Library/mail'
    alias smart='diskutil info disk0 | grep SMART' # display SMART status of hard drive
    # Hall of the Mountain King
    alias cello='say -v cellos "di di di di di di di di di di di di di di di di di di di di di di di di di di"'
    # alias to show all Mac App store apps
    alias apps='mdfind "kMDItemAppStoreHasReceipt=1"'
    # reset Address Book permissions in Mountain Lion (and later presumably)
    alias resetaddressbook='tccutil reset AddressBook'
    # refresh brew by upgrading all outdated casks
    alias freshbrew='brew outdated | while read cask; do brew upgrade $cask; done'
    alias newbrew='brew install'
    # rebuild Launch Services to remove duplicate entries on Open With menu
    alias rebuildopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.fram ework/Support/lsregister -kill -r -domain local -domain system -domain user'
    alias htop='sudo htop'
fi


# -------------------------------------------------------------------
# remote machines
# -------------------------------------------------------------------
alias rb='ssh -N -f -L 6697:irc.redbrick.dcu.ie:6667 pygmalion.redbrick.dcu.ie'
#alias rbvm ='ssh -L 5900:136.206.16.1:5913 butlerx@login.redbrick.dcu.ie'

# -------------------------------------------------------------------
# database
# -------------------------------------------------------------------
alias psqlstart='/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start'
alias psqlstop='/usr/local/pgsql/bin/pg_ctl stop'
alias mysql='mysql -u butlerx'
alias mysqladmin='mysqladmin -u root'


# -------------------------------------------------------------------
# Mercurial (hg)
# -------------------------------------------------------------------
alias h='hg status'
alias hc='hg commit'
alias push='hg push'
alias pull='hg pull'
alias clone='hg clone'

# -------------------------------------------------------------------
# Git
# -------------------------------------------------------------------
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gpl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'
alias gta='git tag -a -m'
alias gf='git reflog'
alias gv='git log --pretty=format:'%s' | cut -d " " -f 1 | sort | uniq -c | sort -nr'

# leverage aliases from ~/.gitconfig
alias gh='git hist'
alias gt='git today'

# curiosities
# gsh shows the number of commits for the current repos for all developers
alias gsh="git shortlog | grep -E '^[ ]+\w+' | wc -l"

# gu shows a list of all developers and the number of commits they've made
alias gu="git shortlog | grep -E '^[^ ]'"

# -------------------------------------------------------------------
# Python virtualenv
# -------------------------------------------------------------------
alias mkenv='mkvirtualenv'
alias pyon="workon"
alias pyoff="deactivate"

# -------------------------------------------------------------------
# Oddball stuff
# -------------------------------------------------------------------
alias sloc='/usr/local/sloccount/bin/sloccount'
alias adventure='emacs -batch -l dunnet' # play adventure in the console
alias ttop='top -ocpu -R -F -s 2 -n30' # fancy top
alias rm='rm -i' # make rm command (potentially) less destructive
alias cl='clear'
alias vim='nvim'

# Force tmux to use 256 colors
alias tmux='TERM=screen-256color-bce tmux'

# alias to cat this file to display
alias acat='< ~/.zsh/aliases.zsh'
alias fcat='< ~/.zsh/functions.zsh'
alias sz='source ~/.zshrc'


# -------------------------------------------------------------------
# some Octopress helpers
# -------------------------------------------------------------------
alias generate='date ; rake generate ; date ;'
alias gen='date ; rake generate ; date ;'
alias ingen='date ; rake integrate ; generate ; date ;'
alias deploy='rm deploy.log ; rake deploy > deploy.log ; tail -n 3 deploy.log ;'
alias np='newpost.rb'

# copy .htaccess files for zanshin.net and its image sub-directory
alias htaccess='scp /Users/mark/Projects/octopress/zanshin/source/htaccess/.htaccess markn@markn.webfactional.com:~/webapps/zanshin ; scp /Users/mark/Projects/octopress/zanshin/source/images/.htaccess markn@markn.webfactional.com:~/webapps/zanshin/images ;'

# deploy zanshin.net and move its .htaccess files
alias dz='deploy ; htaccess ;'

# -------------------------------------------------------------------
# Source: http://aur.archlinux.org/packages/lolbash/lolbash/lolbash.sh
# -------------------------------------------------------------------
alias wtf='dmesg'
alias onoz='cat /var/log/errors.log'
alias rtfm='man'
alias visible='echo'
alias invisible='cat'
alias moar='more'
alias icanhas='mkdir'
alias donotwant='rm'
alias dowant='cp'
alias gtfo='mv'
alias hai='cd'
alias plz='pwd'
alias inur='locate'
alias nomz='ps aux | less'
alias nomnom='killall'
alias cya='reboot'
alias kthxbai='halt'
