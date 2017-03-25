#!/bin/bash

git clone https://github.com/butlerx/dotfiles.git $HOME/.dotfiles
# nvim or vim
which nvim;
NVIM_INSTALL=$?
if [ $NVIM_INSTALL -eq 0 ]; then
  mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
  ln -s ~/.vim $XDG_CONFIG_HOME/nvim
  ln -s $HOME/.dotfiles/vimrc $XDG_CONFIG_HOME/nvim/init.vim
  nvim +qall
else
  ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc
  vim +qall
fi
# zsh
ln -s $HOME/.dotfiles/zshrc $HOME/.zshrc
pip install --user thefuck
cd $HOME/.dotfiles
git submodule init
git submodule update
# tmux
ln -s $HOME/.dotfiles/tmux/tmux.conf $HOME/.tmux.conf
pip install --user psutil
tmux source-file $HOME/.tmux.conf
# weechat
ln -s $HOME/.dotfiles/weechat $HOME/.weechat
# Git
ln -s $HOME/.dotfiles/gitconfig $HOME/.gitconfig
echo "Enter Github username: "
read $GITHUB_USER
echo "Enter Github email: "
read $GITHUB_EMAIL
git config --global user.name $GITHUB_USER
git config --global github.user $GITHUB_USER
git config --global user.name $GITHUB_EMAIL
