" C files
autocmd BufNewFile,BufRead
      \ ?*.c
      \,?*.h
      \ setfiletype c
" C++ files
autocmd BufNewFile,BufRead
      \ ?*.cpp
      \,?*.cxx
      \,?*.c++
      \,?*.hh
      \ setfiletype cpp
