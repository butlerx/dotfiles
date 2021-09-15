" BIND zone file
autocmd BufNewFile,BufRead
      \ */bind/db.?*
      \,*/namedb/db.?*
      \,named.root
      \ setfiletype bindzone

" BIND configuration file
autocmd BufNewFile,BufRead
      \ named.conf
      \,rndc.conf
      \,rndc.key
      \ setfiletype named
