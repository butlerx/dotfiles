"
" shebang_create_exec.vim: Make a file executable on first save if it starts with a
" shebang.
"
" Author: Tom Ryder <tom@sanctum.geek.nz>
" License: Same as Vim itself
"
if exists('g:loaded_shebang_create_exec') || &compatible
  finish
endif
if !has('autocmd') || !has('unix') || !exists('*shellescape')
  finish
endif
let g:loaded_shebang_create_exec = 1

" Set up hook for before writes to check the buffer for new shebangs
augroup shebang_create_exec
  autocmd!
  autocmd BufWritePre *
        \ call shebang_create_exec#Check(expand('<afile>:p'))
augroup END
