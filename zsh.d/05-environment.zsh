#!/usr/bin/env zsh

# Currently this path is appended to dynamically when picking a ruby version
# zshenv has already started PATH with rbenv so append only here

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS="-arch $(uname -m)"
# Do not derive GPG_TTY from zsh's $TTY here. .zshenv already does the right thing
# (export GPG_TTY=$(tty)); this line ran after it and clobbered the good value. $TTY
# is empty whenever zsh has no controlling terminal, so the clobber exported an empty
# GPG_TTY, gpg-agent received ttyname="", and pinentry died with:
#   gpg: signing failed: Inappropriate ioctl for device
# $(tty) is unconditionally correct. The second line matters because gpg-agent
# outlives the login session: reconnect over SSH and you get a new /dev/pts/N while
# the agent is still holding the previous one. updatestartuptty hands it the current.
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
export LESS='--ignore-case --raw-control-chars'
export PAGER='bat'
export EDITOR='nvim'
# pets defaults its config dir to ~/pets, which does not exist here; the
# configs live in this repo. 0.5.1+ reads PETS_DIR, so plain `pets` works.
export PETS_DIR="$HOME/.dotfiles"

# CTAGS Sorting in VIM/Emacs is better behaved with this in place
export LC_COLLATE=C
export LANG="en_US.UTF-8"

# Virtual Environment Stuff
export WORKON_HOME="$HOME"/.virtualenvs
#source /usr/local/bin/virtualenvwrapper.sh

#export HOMEBREW_GITHUB_API_TOKEN=
export GOPATH="$HOME"/go
if [[ -d /usr/lib/jvm/default ]]; then
	export JAVA_HOME=/usr/lib/jvm/default
elif [[ -x /usr/libexec/java_home ]]; then
	export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)" || true
fi
export PYTHON_USER="$HOME"/.local/bin
# export RUBY_USER=$(ruby -e 'print Gem.user_dir')
#export JAVA_HOME="$(jrunscript -e 'java.lang.System.out.println(java.lang.System.getProperty("java.home"));')"

# NVM — lazy-loaded for fast shell startup
export NVM_DIR="$HOME/.nvm"

_nvm_lazy_load() {
	unset -f nvm node npm npx 2>/dev/null
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() {
	_nvm_lazy_load
	nvm "$@"
}
node() {
	_nvm_lazy_load
	node "$@"
}
npm() {
	_nvm_lazy_load
	npm "$@"
}
npx() {
	_nvm_lazy_load
	npx "$@"
}

# Bun
export BUN_INSTALL="$HOME/.bun"

export PATH="$HOME/.cargo/bin:/usr/local/go/bin:$BUN_INSTALL/bin:$PATH:/usr/local/bin:$GOPATH/bin:$PYTHON_USER"

export BAT_THEME="Monokai Extended"
export BAT_PAGER="less -RF"
export ANSIBLE_COW_SELECTION=random

# Cross-platform tool hooks
(($+commands[direnv])) && eval "$(direnv hook zsh)"
(($+commands[mise])) && eval "$(mise activate zsh)"
