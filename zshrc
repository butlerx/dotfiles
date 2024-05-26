# pets: package=zsh
# pets: symlink=/home/butlerx/.zshrc

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
