if exists('g:current_compiler')
  finish
endif
let g:current_compiler = 'bash'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" 7.4.191 is the earliest version with the :S file name modifier, which we
" really should use if we can
if v:version >= 704 || v:version == 704 && has('patch191')
  CompilerSet makeprg=bash\ -n\ --\ %:S
else
  CompilerSet makeprg=bash\ -n\ --\ %
endif
CompilerSet errorformat=%f:\ line\ %l:\ %m
