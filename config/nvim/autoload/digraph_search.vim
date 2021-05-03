" Search for digraphs
function! digraph_search#Search() abort

  " Get the search string
  let l:search = input('Digraph search: ')
  if !strlen(l:search)
    return
  endif

  " Look for the uppercased search in the table
  let l:results = []
  for l:digraph in digraph_search#Digraphs()
    if stridx(l:digraph['name'], toupper(l:search)) != -1
      call add(l:results, l:digraph)
    endif
  endfor

  " Print results, or if there weren't any, say so
  redraw
  echo 'Digraphs matching '.toupper(l:search).':'
  if len(l:results)
    for l:result in l:results
      echo l:result['char']
            \.'  '.l:result['keys']
            \.'  '.l:result['name']
    endfor
  else
    echo 'None!'
  endif

endfunction

" Get private memoized list of digraph dictionary objects
function! digraph_search#Digraphs() abort

  " We haven't been called yet; get the digraph list
  if !exists('s:digraphs')
    let s:digraphs = []
    let l:table = 0
    for l:line in readfile($VIMRUNTIME.'/doc/digraph.txt')

      " Flag whether we're in one of the digraph tables; look for the heading
      let l:table = l:table && strlen(l:line)
            \ || l:line =~# '\C\*digraph-table\%(-mbyte\)\=\*$'
      " Skip to next line if not in a table
      if !l:table
        continue
      endif

      " Check whether this row matches a parseable digraph row
      let l:match = matchlist(l:line,
             \   '^\(\S\)\+\s\+'
             \ . '\(\S\S\)\s\+'
             \ . '\%(0x\)\=\x\+\s\+'
             \ . '\d\+\s\+'
             \ . '\(.\+\)'
             \ )
      " Skip to next line if not a table row match
      if !len(l:match)
        continue
      endif

      " Add to the digraphs list; key is digraph, value is full name
      call add(s:digraphs, {
            \ 'char': l:match[1],
            \ 'keys': l:match[2],
            \ 'name': l:match[3],
            \ })
    endfor
  endif

  " Return the list, whether newly-generated or from the first call
  return s:digraphs

endfunction
