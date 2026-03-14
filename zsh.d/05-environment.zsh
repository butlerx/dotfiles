#!/usr/bin/env zsh

# Currently this path is appended to dynamically when picking a ruby version
# zshenv has already started PATH with rbenv so append only here

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
export ARCHFLAGS="-arch $(uname -m)"
export GPG_TTY="$TTY"
export LESS='--ignore-case --raw-control-chars'
export PAGER='bat'
export EDITOR='nvim'

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
