for file in ${HOME}/.dotfiles/zsh.d/*.zsh; do
  # shellcheck disable=SC1091
  # shellcheck source=~/.dotfiles/zsh/*.zsh
  source "$file"
done
fpath=(~/.dotfiles/zsh-completions $fpath)
source "$HOME/.zprofile"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# The next line updates PATH for Netlify's Git Credential Helper.
if [ -f '/home/butlerx/.netlify/helper/path.zsh.inc' ]; then
  source '/home/butlerx/.netlify/helper/path.zsh.inc'
fi
