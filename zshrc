for file in ${HOME}/.dotfiles/zsh/*.zsh; do
  source "$file"
done
#eval "$(thefuck --alias)"
fpath=(/usr/local/share/zsh-completions $fpath)
