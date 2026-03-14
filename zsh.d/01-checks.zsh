# checks (stolen from zshuery)
local _uname
_uname="$(uname)"

if [[ "$_uname" == 'Linux' ]]; then
	export IS_LINUX=1
fi

if [[ "$_uname" == 'Darwin' ]]; then
	export IS_MAC=1
fi

if (($+commands[brew])); then
	export HAS_BREW=1
fi

if (($+commands[apt-get])); then
	export HAS_APT=1
fi

if (($+commands[dnf])); then
	export HAS_YUM=1
fi

if (($+commands[aurman])); then
	export HAS_YAOURT=1
fi
