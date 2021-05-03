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
