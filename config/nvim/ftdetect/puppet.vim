" Puppet files
autocmd BufNewFile,BufRead
      \ ?*.pp
      \ setfiletype puppet
autocmd BufNewFile,BufRead
      \ ?*.epp
      \ setfiletype embeddedpuppet
