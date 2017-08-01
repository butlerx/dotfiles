for file in ${HOME}/.dotfiles/zsh/*.zsh; do
  # shellcheck disable=SC1091
  # shellcheck source=~/.dotfiles/zsh/*.zsh
  source "$file"
done
if [[ -r ${HOME}/.cargo/env ]]; then
  source "$HOME/.cargo/env"
fi
source <(kompose completion zsh)
source <(kubectl completion zsh)
eval "$(thefuck --alias)"
fpath=(/usr/local/share/zsh-completions $fpath)
