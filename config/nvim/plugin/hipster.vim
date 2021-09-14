if exists('g:loaded_hipster') | finish | endif

" Define :Hipster command to dump in a paragraph of Hipster ipsum
command! -nargs=0 Hipster :lua require'hipster'.output()
let g:loaded_hipster = 1
