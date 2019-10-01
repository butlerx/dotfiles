#!/usr/bin/env sh

set -ex

git clone https://github.com/butlerx/dotfiles.git "$HOME/.dotfiles"
# nvim or vim
which nvim
NVIM_INSTALL=$?
mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
if [ $NVIM_INSTALL -eq 0 ]; then
	ln -s "$HOME/.dotfiles/vimrc.d" "$XDG_CONFIG_HOME/nvim"
	nvim +qall
else
	ln -s "$HOME/.dotfiles/vimrc.d" "$XDG_CONFIG_HOME/.vim"
	ln -s "$XDG_CONFIG_HOME/.vim/init.vim" "$HOME/.vimrc"
	vim +qall
fi
# zsh
ln -s "$HOME/.dotfiles/zshrc" "$HOME/.zshrc"
cd "$HOME/.dotfiles" || exit
git submodule init
git submodule update
# tmux
ln -s "$HOME/.dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"
pip install --user psutil
tmux source-file "$HOME/.tmux.conf"
# weechat
ln -s "$HOME/.dotfiles/weechat" "$HOME/.weechat"
# Git
ln -s "$HOME/.dotfiles/gitconfig" "$HOME/.gitconfig"
echo "Enter Github username: "
read -r GITHUB_USER
echo "Enter Github email: "
read -r GITHUB_EMAIL
git config --global user.name "$GITHUB_USER"
git config --global github.user "$GITHUB_USER"
git config --global user.name "$GITHUB_EMAIL"
# X11
echo "Do you use i3? (y/N)"
read -r answer
if echo "$answer" | grep -iq "^y"; then
	ln -s "$HOME/.dotfiles/xinitrc" "$HOME/.xinitrc"
	ln -s "$HOME/.dotfiles/i3" "$HOME/.i3"
	ln -s "$HOME/.dotfiles/polybar" "$HOME/.config/polybar/config"
	git clone https://github.com/butlerx/bash-bin.git "$HOME/bin"
	echo "This setup uses rofi, polybar, nautalis and feh which youll need to setup with your package manager"
else
	echo "To each there own"
fi
