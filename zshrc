# pets: package=zsh
# pets: package=cargo:exa
# pets: package=bat
# pets: symlink=~/.zshrc

for file in ${HOME}/.dotfiles/zsh.d/*.zsh; do
	# shellcheck disable=SC1091
	# shellcheck source=~/.dotfiles/zsh/*.zsh
	source "$file"
done
fpath=(~/.dotfiles/zsh-completions $fpath)
source "$HOME/.zprofile"

# bun completions
[ -s "/home/cianbutler/.bun/_bun" ] && source "/home/cianbutler/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/butlerx/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
