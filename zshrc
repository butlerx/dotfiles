# pets: package=zsh
# pets: symlink=/home/butlerx/.zshrc

for file in ${HOME}/.dotfiles/zsh.d/*.zsh; do
	# shellcheck disable=SC1091
	# shellcheck source=~/.dotfiles/zsh/*.zsh
	source "$file"
done
fpath=(~/.dotfiles/zsh-completions $fpath)
source "$HOME/.zprofile"
