if exists('g:current_compiler')
  finish
endif
let g:current_compiler = 'vimlint'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=vint\ --\ %:S
CompilerSet errorformat=%f:%l:%c:\ %m
