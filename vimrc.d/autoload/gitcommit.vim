" Choose the color column depending on non-comment line count
function! gitcommit#CursorColumn() abort

  " If we can find a line after the first that isn't a comment, we're
  " composing the message
  for l:num in range(1, line('$'))
    if l:num == 1
      continue
    endif
    let l:line = getline(l:num)
    if strpart(l:line, 0, 1) !=# '#'
      return '+1'
    elseif l:line =~# '^# -\{24} >8 -\{24}$'
      break
    endif
  endfor

  " Otherwise, we're still composing our subject
  return '51'

endfunction
