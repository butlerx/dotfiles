if exists('g:current_compiler')
  finish
endif
let g:current_compiler = 'shellcheck'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" Build :CompilerSet command based on buffer shell type
let s:set = 'CompilerSet makeprg=shellcheck\ -e\ SC1090\ -f\ gcc'
if exists('b:is_bash')
  let s:set = s:set . '\ -s\ bash'
elseif exists('b:is_kornshell')
  let s:set = s:set . '\ -s\ ksh'
else
  let s:set = s:set . '\ -s\ sh'
endif

execute s:set . '\ --\ %:S'
CompilerSet errorformat=%f:%l:%c:\ %m\ [SC%n]
