" Quote lines in mail and mail-based formats: Markdown, Git commits, etc

" Operator function wrapper for the mapping to call
function! quote#Quote() abort
  set operatorfunc=quote#QuoteOpfunc
  return 'g@'
endfunction

" Quoting operator function
function! quote#QuoteOpfunc(type) abort

  " May as well make this configurable
  let l:char = exists('b:quote_char')
        \ ? b:quote_char
        \ : '>'

  " Iterate over each matched line
  for l:li in range(line('''['), line(''']'))

    " Get current line text
    let l:cur = getline(l:li)

    " Don't quote the first or last lines if they're blank
    if !strlen(l:cur) && (l:li == line('''[') || l:li == line(''']'))
      continue
    endif

    " Only add a space after the quote character if this line isn't already
    " quoted with the same character
    let l:new = l:cur[0] == l:char
          \ ? l:char.l:cur
          \ : l:char.' '.l:cur
    call setline(l:li, l:new)

  endfor

endfunction

" Tack on reformatting the edited text afterwards
function! quote#QuoteReformat() abort
  set operatorfunc=quote#QuoteReformatOpfunc
  return 'g@'
endfunction

" Wrapper operator function to reformat quoted text afterwards
function! quote#QuoteReformatOpfunc(type) abort
  call quote#QuoteOpfunc(a:type)
  normal! '[gq']
endfunction
