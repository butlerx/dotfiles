source ${HOME}/.dotfiles/zsh/checks.zsh
source ${HOME}/.dotfiles/zsh/colors.zsh
source ${HOME}/.dotfiles/zsh/setopt.zsh
source ${HOME}/.dotfiles/zsh/exports.zsh
source ${HOME}/.dotfiles/zsh/prompt.zsh
source ${HOME}/.dotfiles/zsh/completion.zsh
source ${HOME}/.dotfiles/zsh/aliases.zsh
source ${HOME}/.dotfiles/zsh/bindkeys.zsh
source ${HOME}/.dotfiles/zsh/functions.zsh
source ${HOME}/.dotfiles/zsh/history.zsh
source ${HOME}/.dotfiles/zsh/zsh_hooks.zsh
source ${HOME}/.dotfiles/zsh/iterm2_shell_integration.zsh
eval "$(thefuck --alias)"
fpath=(/usr/local/share/zsh-completions $fpath)

if [[ -r /usr/lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh
fi
if [[ -r /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi
if [[ -r /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi
if [[ -r /usr/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh
fi
source /usr/share/nvm/init-nvm.sh
