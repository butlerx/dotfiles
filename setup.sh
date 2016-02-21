#vim
ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
#zsh
ln -s $HOME/.dotfiles/zshrc $HOME/.zshrc
#tmux
ln -s $HOME/.dotfiles/.tmux/.tmux.conf $HOME/.tmux.conf
cd $HOME/.dotfiles/.tmux/vendor/tmux-mem-cpu-load
cmake .
make
sudo make install
cd $HOME
tmux source-file $HOME/.tmux.conf
