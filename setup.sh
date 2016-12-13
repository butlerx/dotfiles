#vim
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
ln -s ~/.vim $XDG_CONFIG_HOME/nvim
ln -s $HOME/.dotfiles/vimrc $XDG_CONFIG_HOME/nvim/init.vim
nvim +qall
#zsh
ln -s $HOME/.dotfiles/zshrc $HOME/.zshrc
#tmux
ln -s $HOME/.dotfiles/tmux/tmux.conf $HOME/.tmux.conf
sudo pip install psutil
sudo cp ~/.dotfiles/tmux/vendor/basic-cpu-and-memory.tmux /usr/local/bin/tmux-mem-cpu-load
sudo chmod +x /usr/local/bin/tmux-mem-cpu-load
tmux source-file $HOME/.tmux.conf
