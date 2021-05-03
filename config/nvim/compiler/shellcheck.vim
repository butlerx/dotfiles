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

" 7.4.191 is the earliest version with the :S file name modifier, which we
" really should use if we can
if v:version >= 704 || v:version == 704 && has('patch191')
  execute s:set . '\ --\ %:S'
else
  execute s:set . '\ --\ %'
endif
CompilerSet errorformat=%f:%l:%c:\ %m\ [SC%n]
