source ${HOME}/.dotfiles/zsh/checks.zsh
source ${HOME}/.dotfiles/zsh/colors.zsh
source ${HOME}/.dotfiles/zsh/setopt.zsh
source ${HOME}/.dotfiles/zsh/exports.zsh
if [[ -r /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme ]]; then
	source  ${HOME}/.dotfiles/zsh/theme.zsh
else
	source ${HOME}/.dotfiles/zsh/prompt.zsh
fi
source ${HOME}/.dotfiles/zsh/completion.zsh
source ${HOME}/.dotfiles/zsh/aliases.zsh
source ${HOME}/.dotfiles/zsh/bindkeys.zsh
source ${HOME}/.dotfiles/zsh/functions.zsh
source ${HOME}/.dotfiles/zsh/history.zsh
if [[ -r /usr/share/nvm/init-nvm.sh ]]; then
	source /usr/share/nvm/init-nvm.sh
fi
source ${HOME}/.dotfiles/zsh/zsh_hooks.zsh
source ${HOME}/.dotfiles/zsh/iterm2_shell_integration.zsh
eval "$(thefuck --alias)"
eval "$(rbenv init -)"
fpath=(/usr/local/share/zsh-completions $fpath)
