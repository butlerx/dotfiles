precmd() {
	# vcs_info
	# Put the string "hostname::/full/directory/path" in the title bar:
	echo -ne "\\e]2;$PWD\\a"

	# Put the parentdir/currentdir in the tab
	echo -ne "\\e]1;$PWD:h:t/$PWD:t\\a"
}

set_running_app() {
	printf "\\e]1; %s:t:$(history "$HISTCMD" | cut -b7-) \\a" "$PWD"
}

preexec() {
	set_running_app
}

postexec() {
	set_running_app
}

# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
	# Ensure NVM is loaded (triggers lazy-load if needed)
	if ! (($+functions[nvm_find_nvmrc])); then
		# NVM not yet loaded — load it now
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	fi

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
