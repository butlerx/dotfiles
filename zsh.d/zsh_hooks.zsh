function precmd() {
	# vcs_info
	# Put the string "hostname::/full/directory/path" in the title bar:
	echo -ne "\\e]2;$PWD\\a"

	# Put the parentdir/currentdir in the tab
	echo -ne "\\e]1;$PWD:h:t/$PWD:t\\a"
}

function set_running_app() {
	printf "\\e]1; %s:t:$(history "$HISTCMD" | cut -b7-) \\a" "$PWD"
}

function preexec() {
	set_running_app
}

function postexec() {
	set_running_app
}

# place this after nvm initialization!
autoload -U add-zsh-hook

function load-nvmrc() {
	local nvmrc_path
	nvmrc_path="$(nvm_find_nvmrc)"

	if [ -n "$nvmrc_path" ]; then
		local nvmrc_node_version
		nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

		if [ "$nvmrc_node_version" = "N/A" ]; then
			nvm install
		elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
			nvm use
		fi
	elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
		echo "Reverting to nvm default version"
		nvm use default
	fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
