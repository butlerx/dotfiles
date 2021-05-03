" Undo some diff lines
function! diff#prune#Prune(type) abort

  " Choose appropriate line ranges depending on mode
  if a:type ==# 'v' || a:type ==# 'V' || a:type ==# "\<C-V>"
    let l:range = '''<,''>'
  else
    let l:range = '''[,'']'
  endif

  " Reinstate removals and remove addenda; preserve search pattern
  let l:search_save = @/
  silent execute l:range.'substitute/^-/ /e'
  silent execute l:range.'global/^+/d'
  let @/ = l:search_save

  " Now we need to look for any blocks or files to remove if they have no
  " changes in them anymore
  let l:file_changes = 0
  let l:block_changes = 0
  let l:deletions = {}
  for l:li in range(1, line('$') + 1)

    " Flag for the end of the buffer (one past the last line)
    let l:eof = l:li > line('$')

    " If this index corresponds to a real line, cache its value
    if !l:eof
      let l:line = getline(l:li)
      let l:deletions[l:li] = 0
    endif

    " Flags for whether this iteration constitutes the start of a new file, a
    " new block, or a changed line
    let l:file = stridx(l:line, 'diff') == 0 && !l:eof
    let l:block = stridx(l:line, '@@') == 0 && !l:eof
    let l:change = (stridx(l:line, '+') == 0 || stridx(l:line, '-') == 0)
          \ && !l:eof
          \ && exists('l:block_start')

    " End of old file: flag previous file lines for deletion if no changes,
    " clear file start and changes variables
    if l:file || l:eof
      if exists('l:file_start') && l:file_changes == 0
        for l:di in range(l:file_start, l:li - 1)
          let l:deletions[l:di] = 1
        endfor
      endif
      unlet! l:file_start l:file_changes
    endif

    " Start of new file: set start line, start new changes counter
    if l:file
      let l:file_start = l:li
      let l:file_changes = 0
    endif

    " End of old block: flag previous block lines for deletion if no changes,
    " clear block start and changes variables
    if l:block || l:file || l:eof
      if exists('l:block_start') && l:block_changes == 0
        for l:di in range(l:block_start, l:li - 1)
          let l:deletions[l:di] = 1
        endfor
      endif
      unlet! l:block_start l:block_changes
    endif

    " Start of new block: set start line, start new changes counter
    if l:block
      let l:block_start = l:li
      let l:block_changes = 0
    endif

    " If this is a changed line, bump the counters for this file and block
    if l:change
      let l:file_changes += 1
      let l:block_changes += 1
    endif

  endfor

  " Delete any flagged lines, going in reverse order so we don't reset any
  " indices as we go
  let l:di = line('$')
  while l:di > 0
    if l:deletions[l:di]
      silent execute l:di.'delete'
    endif
    let l:di -= 1
  endwhile

endfunction
