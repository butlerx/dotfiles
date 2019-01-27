for file in ${HOME}/.dotfiles/zsh.d/*.zsh; do
  # shellcheck disable=SC1091
  # shellcheck source=~/.dotfiles/zsh/*.zsh
  source "$file"
done
if [ -f "$HOME/bin/complete" ]; then
  source "$HOME/bin/complete"
fi
fpath=(/usr/local/share/zsh-completions $fpath)
source "$HOME/.zprofile"
