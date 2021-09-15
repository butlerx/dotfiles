if exists('g:current_compiler')
  finish
endif
let g:current_compiler = 'zsh'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=zsh\ -n\ --\ %:S
CompilerSet errorformat=%f:%l:\ %m
