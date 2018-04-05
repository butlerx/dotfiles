for file in ${HOME}/.dotfiles/zsh.d/*.zsh; do
  # shellcheck disable=SC1091
  # shellcheck source=~/.dotfiles/zsh/*.zsh
  source "$file"
done
if type kompose > /dev/null; then
  source <(kompose completion zsh)
fi
if type kops > /dev/null; then
  source <(kops completion zsh)
fi
if type kubectl > /dev/null; then
  source <(kubectl completion zsh)
fi
fpath=(/usr/local/share/zsh-completions $fpath)
