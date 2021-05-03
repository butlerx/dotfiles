" Don't try to make these corrections if running 'compatible' or if the
" runtime files are too old
if &compatible || v:version < 700
  finish
endif

" If my commit subject is too long, highlight it as an error.
highlight link gitCommitOverflow Error
