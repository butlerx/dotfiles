" Put lines above
function! put_blank_lines#Above() abort
  set operatorfunc=put_blank_lines#AboveOpfunc
  return 'g@^'
endfunction
function! put_blank_lines#AboveOpfunc(type) abort
  silent put! =repeat(nr2char(10), v:count1)
  ']+1
endfunction

" Put lines below
function! put_blank_lines#Below() abort
  set operatorfunc=put_blank_lines#BelowOpfunc
  return 'g@^'
endfunction
function! put_blank_lines#BelowOpfunc(type) abort
  silent put =repeat(nr2char(10), v:count1)
  '[-1
endfunction
