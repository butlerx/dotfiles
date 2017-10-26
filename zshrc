for file in ${HOME}/.dotfiles/zsh.d/*.zsh; do
  # shellcheck disable=SC1091
  # shellcheck source=~/.dotfiles/zsh/*.zsh
  source "$file"
done
source <(kompose completion zsh)
source <(kops completion zsh)
source <(kubectl completion zsh)
fpath=(/usr/local/share/zsh-completions $fpath)
