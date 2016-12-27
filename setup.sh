#!/bin/bash

sudo apt install mednafen zsh ssh vim nvim weechat vlc rxvt-unicode-256color tmux dwb htop git chromium-browser feh -y
#vim
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
ln -s ~/.vim $XDG_CONFIG_HOME/nvim
ln -s $HOME/.dotfiles/vimrc $XDG_CONFIG_HOME/nvim/init.vim
nvim +qall
#zsh
ln -s $HOME/.dotfiles/zshrc $HOME/.zshrc
git submodule init
git submodule update
#tmux
ln -s $HOME/.dotfiles/tmux/tmux.conf $HOME/.tmux.conf
sudo pip install psutil
tmux source-file $HOME/.tmux.conf
