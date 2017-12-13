" Plug initialization
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup Plugins
    au!
    au VimEnter * PlugInstall | source $MYVIMRC
  augroup END
endif
call plug#begin('~/.local/share/nvim')
  source ~/.dotfiles/vimrc.d/vim.plug
call plug#end()

set encoding=utf-8
for g:f in split(glob('~/.dotfiles/vimrc.d/*.vim'), '\n')
  exe 'source' g:f
endfor
