# checks (stolen from zshuery)
if [[ $(uname) == 'Linux' ]]; then
	export IS_LINUX=1
fi

if [[ $(uname) == 'Darwin' ]]; then
	export IS_MAC=1
fi

if [[ -x $(which brew >>/dev/null) ]]; then
	export HAS_BREW=1
fi

if [[ -x $(which apt-get >>/dev/null) ]]; then
	export HAS_APT=1
fi

if [[ -x $(which dnf) ]]; then
	export HAS_YUM=1
fi

if [[ -x $(which yaourt) ]]; then
	export HAS_YAOURT=1
fi
