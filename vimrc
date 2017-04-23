" Plug initialization
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim')
  source ~/.dotfiles/vimrc.d/vim.plug
call plug#end()
for f in split(glob('~/.dotfiles/vimrc.d/*.vim'), '\n')
  exe 'source' f
endfor
