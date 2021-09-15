if exists('g:current_compiler')
  finish
endif
let g:current_compiler = 'ksh'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=ksh\ -n\ --\ %:S
CompilerSet errorformat=%f:\ %l:\ %m
