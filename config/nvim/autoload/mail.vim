" Flag a message as important
function! mail#FlagImportant() abort
  call cursor(1, 1)
  call search('^$')
  -
  call append(line('.'), 'X-Priority: 1')
  call append(line('.'), 'Importance: High')
endfunction

" Flag a message as unimportant
function! mail#FlagUnimportant() abort
  call cursor(1, 1)
  call search('^$')
  -
  call append(line('.'), 'X-Priority: 5')
  call append(line('.'), 'Importance: Low')
endfunction

" Move through quoted paragraphs like normal-mode `{` and `}`
function! mail#NewBlank(count, up, visual) abort

  " Reselect visual selection
  if a:visual
    normal! gv
  endif

  " Flag for whether we've started a block
  let l:block = 0

  " Flag for the number of blocks passed
  let l:blocks = 0

  " Iterate through buffer lines
  let l:num = line('.')
  while a:up ? l:num > 1 : l:num < line('$')

    " If the line is blank
    if getline(l:num) =~# '^[ >]*$'

      " If we'd moved through a non-blank block already, reset that flag and
      " bump up the block count
      if l:block
        let l:block = 0
        let l:blocks += 1
      endif

      " If we've hit the number of blocks, end the loop
      if l:blocks == a:count
        break
      endif

    " If the line is not blank, flag that we're going through a block
    else
      let l:block = 1
    endif

    " Move the line number or up or down depending on direction
    let l:num += a:up ? -1 : 1

  endwhile

  " Move to line if nonzero and not equal to the current line
  if l:num != line('.')
    execute 'normal '.l:num.'G'
  endif

endfunction

" Quick map to strip multiple blank lines in the entire buffer; this comes up
" a lot when replying to stripped HTML mail. This should really be a command,
" but I'll do that Later(TM).
function! mail#ContractMultipleBlankLines() abort
  let l:deletions = []
  let l:blank = 0
  for l:num in range(1, line('$'))
    if getline(l:num) !~# '^[> ]*$'
      let l:blank = 0
    elseif l:blank
      let l:deletions += [l:num - 1]
    else
      let l:blank = 1
    endif
  endfor
  for l:num in reverse(l:deletions)
    execute l:num . 'delete'
  endfor
endfunction
