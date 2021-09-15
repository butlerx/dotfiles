" Git commit messages
autocmd BufNewFile,BufRead
      \ COMMIT_EDITMSG
      \,MERGE_MSG
      \,TAG_EDITMSG
      \ setfiletype gitcommit
" Git config files
autocmd BufNewFile,BufRead
      \ *.git/config
      \,.gitconfig
      \,.gitmodules
      \,gitconfig
      \ setfiletype gitconfig
" Git rebase manifests
autocmd BufNewFile,BufRead
      \ git-rebase-todo
      \ setfiletype gitrebase
