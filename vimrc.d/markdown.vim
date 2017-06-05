" Spell check markdown and limit to 100 charcters
au BufRead,BufNewFile *.md setlocal textwidth=100
au BufRead,BufNewFile *.txt setlocal textwidth=80
au BufRead,BufNewFile *.md setlocal spell
au BufRead,BufNewFile *.txt setlocal spell
set complete+=kspell
