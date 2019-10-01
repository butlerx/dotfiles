" Autoloaded function for vertical_region.vim maps
function! vertical_region#Map(count, up, mode) abort

  " Reselect any selection
  if a:mode ==# 'x'
    normal! gv
  endif

  " Get line and column number
  let l:num = line('.')
  let l:col = col('.')

  " Move up or down through buffer, counting hits as we go
  let l:hits = 0
  while a:up ? l:num > 1 : l:num < line('$')

    " Increment or decrement line number
    let l:num += a:up ? -1 : 1

    " If the line has any non-space characters up to the current column, we
    " have a hit; break the loop as soon as we have the count we need
    let l:line = getline(l:num)
    if strpart(l:line, 0, l:col) =~# '\S'
      let l:hits += 1
      if l:hits == a:count
        break
      endif
    endif

  endwhile

  " If not moving linewise for operator mode and not in first column, move to
  " same column after line jump; is there a way to do this in one jump?
  let l:keys = l:num . 'G0'
  if a:mode ==# 'o'
    let l:keys = 'V' . l:keys
  elseif l:col > 1
    let l:keys .= l:col - 1 . 'l'
  endif

  " Run normal mode commands
  execute 'normal! ' . l:keys

endfunction
