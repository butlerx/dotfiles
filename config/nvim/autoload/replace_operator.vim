" Replace the operated text with the contents of a register
function! replace_operator#Operatorfunc(type) abort

  " If we're using the unnamed register, we'll need to save its current
  " contents, because the deletion we're about to do will overwrite it
  let l:register = g:replace_operator#register
  if l:register ==# '"'
    let l:text = getreg(l:register)
  endif

  " Select or re-select text depending on how we were invoked
  if a:type ==# 'v' || a:type ==# 'V'
    normal! gv
  elseif a:type ==# "\<C-V>"
    echoerr 'Visual block mode replace not supported'
    return
  elseif a:type ==# 'line'
    normal! '[V']
  else
    normal! `[v`]
  endif

  " Delete the text normally so it stacks up in the numbered registers, and
  " then restore the active register's initial value if we just clobbered it
  normal! d
  if l:register ==# '"'
    call setreg(l:register, l:text)
  endif

  " Are we working linewise or characterwise?
  let l:linewise = a:type ==# 'V' || a:type ==# 'line'

  " If the cursor is before the start of the last changed text, we've deleted
  " to the end of line (characterwise) or the end of buffer (linewise) and
  " have been forced to move back and up respectively. If this is the case,
  " we'll need to paste after the current point, not before it.
  if l:linewise && line('.') < line("'[")
        \ || !l:linewise && col('.') < col("'[")
    let l:paste = 'p'
  else
    let l:paste = 'P'
  endif

  " Run the paste
  execute 'normal "'.l:register.l:paste

endfunction

" Helper function for normal mode map
function! replace_operator#MapNormal(register) abort
  let g:replace_operator#register = a:register
  set operatorfunc=replace_operator#Operatorfunc
endfunction

" Helper function for visual mode map
function! replace_operator#MapVisual(register, visualmode) abort
  let g:replace_operator#register = a:register
  call replace_operator#Operatorfunc(a:visualmode)
endfunction
