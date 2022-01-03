for file in ${HOME}/.dotfiles/zsh.d/*.zsh; do
  # shellcheck disable=SC1091
  # shellcheck source=~/.dotfiles/zsh/*.zsh
  source "$file"
done
fpath=(~/.dotfiles/zsh-completions $fpath)
source "$HOME/.zprofile"
source "/opt/google-cloud-sdk/completion.zsh.inc"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/.deno/bin:$PATH"

# The next line updates PATH for Netlify's Git Credential Helper.
if [ -f '/home/butlerx/.netlify/helper/path.zsh.inc' ]; then
  source '/home/butlerx/.netlify/helper/path.zsh.inc'
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/grr grr
