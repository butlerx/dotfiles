if exists('g:current_compiler')
  finish
endif
let g:current_compiler = 'perlcritic'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=perlcritic\ --verbose\ 1\ --\ %:S
CompilerSet errorformat=%f:%l:%c:%m
