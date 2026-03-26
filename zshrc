# pets: package=zsh
# pets: package=cargo:exa
# pets: package=bat
# pets: symlink=~/.zshrc

# Set up fpath before compinit
fpath=(~/.dotfiles/zsh-completions $HOME/.docker/completions $fpath)

# Single compinit — uses cached .zcompdump for speed
autoload -Uz compinit && compinit -C

for file in ${HOME}/.dotfiles/zsh.d/*.zsh; do
	# shellcheck disable=SC1091
	# shellcheck source=~/.dotfiles/zsh/*.zsh
	source "$file"
done

source "$HOME/.zprofile"

# bun completions
[ -s "/Users/cbutler/.bun/_bun" ] && source "/Users/cbutler/.bun/_bun"
