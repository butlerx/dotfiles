autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ] && [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
export NVM_DIR=$HOME/.dotfiles/nvm
if [[ -r /usr/share/nvm/init-nvm.sh ]]; then
  source /usr/share/nvm/init-nvm.sh --no-use
  source /usr/share/nvm/bash_completion
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
elif [[ -r $NVM_DIR/nvm.sh ]]; then
  source $NVM_DIR/nvm.sh --no-use
  source $NVM_DIR/bash_completion
  [ -e "$NVM_DIR/nvm-exec" ] || (mkdir -p "$NVM_DIR" && (echo '/usr/share/nvm/nvm-exec "$@"' > "$NVM_DIR/nvm-exec") && chmod +x "$NVM_DIR/nvm-exec")
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi
