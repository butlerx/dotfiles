" Mail messages
autocmd BufNewFile,BufRead
      \ ?*.msg
      \,mutt-*-[0-9]\+-[0-9]\+-[0-9]\+
      \ setfiletype mail
" Mail messages
autocmd BufNewFile,BufRead
      \ aliases
      \ setfiletype mailaliases
