for file in ${HOME}/.dotfiles/zsh/*.zsh; do
  source "$file"
done
source $HOME/.cargo/env
eval "$(thefuck --alias)"
fpath=(/usr/local/share/zsh-completions $fpath)

export PATH="$HOME/.yarn/bin:$PATH"
