" Operator prompts for a command if it doesn't have one from a prior run, and
" then runs the command on the selected text
function! colon_operator#Operatorfunc(type) abort
  if !exists('s:command')
    let s:command = input('g:', '', 'command')
  endif
  execute '''[,'']'.s:command
endfunction

" Clear command so that we get prompted to input it, set operator function,
" and return <expr> motions to run it
function! colon_operator#Map() abort
  unlet! s:command
  set operatorfunc=colon_operator#Operatorfunc
  return 'g@'
endfunction
