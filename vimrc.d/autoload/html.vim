" Make a bare URL into a link to itself
function! html#UrlLink() abort

  " Yank this whole whitespace-separated word
  normal! yiW
  " Open a link tag
  normal! i<a href="">
  " Paste the URL into the quotes
  normal! hP
  " Move to the end of the link text URL
  normal! E
  " Close the link tag
  normal! a</a>

endfunction

" Update a timestamp
function! html#TimestampUpdate() abort
  if !&modified
    return
  endif
  let l:cv = winsaveview()
  call cursor(1,1)
  let l:li = search('\C^\s*<em>Last updated: .\+</em>$', 'n')
  if l:li
    let l:date = substitute(system('date -u'), '\C\n$', '', '')
    let l:line = getline(l:li)
    call setline(l:li, substitute(l:line, '\C\S.*',
          \ '<em>Last updated: '.l:date.'</em>', ''))
  endif
  call winrestview(l:cv)
endfunction
