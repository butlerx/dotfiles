for file in ${HOME}/.dotfiles/zsh/*.zsh; do
  source "$file"
done
if [[ -r ${HOME}/.cargo/env ]]; then
  source "$HOME/.cargo/env"
fi
eval "$(thefuck --alias)"
fpath=(/usr/local/share/zsh-completions $fpath)
