#!/bin/bash

git clone https://github.com/butlerx/dotfiles.git .dotfiles
# vim
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
ln -s ~/.vim $XDG_CONFIG_HOME/nvim
ln -s $HOME/.dotfiles/vimrc $XDG_CONFIG_HOME/nvim/init.vim
nvim +qall
# zsh
ln -s $HOME/.dotfiles/zshrc $HOME/.zshrc
git submodule init
git submodule update
# tmux
ln -s $HOME/.dotfiles/tmux/tmux.conf $HOME/.tmux.conf
pip install --user psutil
tmux source-file $HOME/.tmux.conf
# weechat
ln -s $HOME/.dotfiles/weechat $HOME/.weechat
