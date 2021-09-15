" VimL files
autocmd BufNewFile,BufRead
      \ ?*.vim
      \,*.exrc
      \,*.gvimrc
      \,*.vimrc
      \,_exrc
      \,_gvimrc
      \,_vimrc
      \,exrc
      \,gvimrc
      \,vimrc
      \ setfiletype vim
"
" Vim help files
autocmd BufNewFile,BufRead
      \ ~/.vim/doc/?*.txt
      \,*/vim-*/doc/?*.txt
      \,*/*.vim/doc/?*.txt
      \,$VIMRUNTIME/doc/?*.txt
      \ setfiletype help

" .viminfo files
autocmd BufNewFile,BufRead
  \ .viminfo
  \ setfiletype viminfo
