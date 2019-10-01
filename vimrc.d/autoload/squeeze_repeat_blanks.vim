" Reduce all groups of blank lines within range to the last line in that
" group, deleting the others.
function! squeeze_repeat_blanks#Squeeze(start, end) abort

  " List of line numbers to delete
  let l:deletions = []

  " Flag for whether we've encountered a blank line group
  let l:group = 0

  " Pattern for what constitutes a 'blank'; configurable per-buffer
  let l:pattern = get(b:, 'squeeze_repeat_blanks_blank', '^$')

  " Iterate through the lines, collecting numbers to delete
  for l:num in range(a:start, a:end)

    " End a blank group if the current line doesn't match the pattern
    if getline(l:num) !~# l:pattern
      let l:group = 0

    " If we've found a repeated blank line, flag the one before it for
    " deletion; this way we end up with the last line of the group
    elseif l:group
      let l:deletions += [l:num - 1]

    " If this is the first blank line, start a group
    else
      let l:group = 1
    endif

  endfor

  " Delete each flagged line, in reverse order so that renumbering doesn't
  " bite us
  for l:num in reverse(l:deletions)
    silent execute l:num . 'delete'
  endfor

  " Report how many lines were deleted
  echomsg len(l:deletions) . ' deleted'

endfunction
