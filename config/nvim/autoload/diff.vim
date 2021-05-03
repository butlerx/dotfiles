" Move between diff block headers
function! diff#MoveBlock(count, up, visual) abort

  " Reselect visual selection
  if a:visual
    normal! gv
  endif

  " Flag for the number of blocks passed
  let l:blocks = 0

  " Iterate through buffer lines
  let l:num = line('.')
  while a:up ? l:num > 1 : l:num < line('$')
    let l:num += a:up ? -1 : 1
    if getline(l:num) =~# '^@@'
      let l:blocks += 1
      if l:blocks == a:count
        break
      endif
    endif
  endwhile

  " Move to line if nonzero and not equal to the current line
  if l:num != line('.')
    execute 'normal '.l:num.'G'
  endif

endfunction
