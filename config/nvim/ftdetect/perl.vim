" Perl 5 files
autocmd BufNewFile,BufRead
      \ ?*.pl
      \,?*.pm
      \,*/t/?*.t
      \,*/xt/?*.t
      \,Makefile.PL
      \ setfiletype perl

" Perl 6 files
autocmd BufNewFile,BufRead
      \ ?*.p6
      \,?*.pl6
      \,?*.pm6
      \ setfiletype perl6

" Perl 5 POD files
autocmd BufNewFile,BufRead
      \ ?*.pod
      \ setfiletype pod

" Perl 6 POD files
autocmd BufNewFile,BufRead
      \ ?*.pod6
      \ setfiletype pod6

" Perl XS
autocmd BufNewFile,BufRead
      \ ?*.xs
      \ setfiletype xs
