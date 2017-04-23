<<<<<<< HEAD
source ${HOME}/.dotfiles/zsh/checks.zsh
source ${HOME}/.dotfiles/zsh/chip.zsh
source ${HOME}/.dotfiles/zsh/colors.zsh
source ${HOME}/.dotfiles/zsh/setopt.zsh
source ${HOME}/.dotfiles/zsh/exports.zsh
source ${HOME}/.dotfiles/zsh/completion.zsh
source ${HOME}/.dotfiles/zsh/aliases.zsh
source ${HOME}/.dotfiles/zsh/bindkeys.zsh
source ${HOME}/.dotfiles/zsh/functions.zsh
source ${HOME}/.dotfiles/zsh/history.zsh
source ${HOME}/.dotfiles/zsh/nvm.zsh
source ${HOME}/.dotfiles/zsh/zsh_hooks.zsh
if [[ -r ${HOME}/.dotfiles/powerlevel9k/powerlevel9k.zsh-theme ]]; then
  source ${HOME}/.dotfiles/powerlevel9k/powerlevel9k.zsh-theme
	source ${HOME}/.dotfiles/zsh/theme.zsh
else
	source ${HOME}/.dotfiles/zsh/prompt.zsh
=======
for file in ${HOME}/.dotfiles/zsh/*.zsh; do
  source "$file"
done
if [[ -r ${HOME}/.cargo/env ]]; then
  source $HOME/.cargo/env
>>>>>>> master
fi
eval "$(thefuck --alias)"
fpath=(/usr/local/share/zsh-completions $fpath)
