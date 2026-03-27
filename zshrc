# pets: package=zsh
# pets: package=cargo:exa
# pets: package=bat
# pets: symlink=~/.zshrc

# Source .zprofile early for Homebrew PATH/env
source "$HOME/.zprofile"

# Set up fpath before compinit — include Homebrew site-functions for mise, etc.
fpath=(~/.dotfiles/zsh-completions $HOME/.docker/completions ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh/site-functions} $fpath)

# compinit — regenerate dump daily, use cache otherwise
autoload -Uz compinit
if [[ -f ~/.zcompdump && $(date +'%j') == $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]]; then
	compinit -C
else
	compinit
fi

for file in ${HOME}/.dotfiles/zsh.d/*.zsh; do
	# shellcheck disable=SC1091
	# shellcheck source=~/.dotfiles/zsh/*.zsh
	source "$file"
done
