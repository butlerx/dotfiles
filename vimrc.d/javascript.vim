let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
set foldmethod=syntax
au BufRead,BufNewFile *.mjs setfiletype javascript

" Invoke the `lebab` tool on the current buffer (https://github.com/lebab/lebab)
"
" Usage:
"
"   :Lebab <transform1> <transform2> [...]
"
" This will run all the transforms specified and replace the buffer with the
" results. The available transforms tab-complete.
"
command! -nargs=+ -complete=custom,s:LebabComplete
      \ Lebab call s:Lebab(<f-args>)
function! s:Lebab(...)
  let l:transforms = a:000
  let l:filename = expand('%:p')

  let l:command_line = 'lebab '.shellescape(l:filename).' --transform '.join(l:transforms, ',')

  let l:new_lines = systemlist(l:command_line)
  if v:shell_error
    echoerr 'There was an error running lebab: '.join(l:new_lines, "\n")
    return
  endif

  %delete _
  call setline(1,l:new_lines)
endfunction

let s:lebab_transforms = []

function! s:LebabComplete(argument_lead, command_line, cursor_position)
  if len(s:lebab_transforms) == 0
    for l:line in systemlist("lebab --help | egrep '^\\s+\\+'")
      call add(s:lebab_transforms, matchstr(l:line, '^\s\++ \zs[a-zA-Z-]\+'))
    endfor
  endif

  return join(sort(s:lebab_transforms), "\n")
endfunction
