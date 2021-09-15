" Apache config
autocmd BufNewFile,BufRead
      \ .htaccess
      \,*/apache*/?*.conf
      \ setfiletype apache
