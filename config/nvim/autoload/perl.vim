" Function to add boilerplate intelligently
function! perl#Boilerplate() abort

  " Flag whether the buffer started blank
  let l:blank = line2byte(line('$') + 1) <= 2

  " This is a .pm file, guess its package name from path
  if expand('%:e') ==# 'pm'

    let l:match = matchlist(expand('%:p'), '.*/lib/\(.\+\).pm$')
    if len(l:match)
      let l:package = substitute(l:match[1], '/', '::', 'g')
    else
      let l:package = expand('%:t:r')
    endif

  " Otherwise, just use 'main'
  else
    let l:package = 'main'
  endif

  " Lines always to add
  let l:lines = [
        \ 'package '.l:package.';',
        \ '',
        \ 'use strict;',
        \ 'use warnings;',
        \ 'use utf8;',
        \ '',
        \ 'use 5.006;',
        \ '',
        \ 'our $VERSION = ''0.01'';',
        \ ''
        \ ]

  " Conditional lines depending on package
  if l:package ==# 'main'
    let l:lines = ['#!perl'] + l:lines
  else
    let l:lines = l:lines + ['', '1;']
  endif

  " Add all the lines in the array
  for l:line in l:lines
    call append(line('.') - 1, l:line)
  endfor

  " If we started in a completely empty buffer, delete the current blank line
  if l:blank
    delete
  endif

  " If we added a trailing '1' for a package, move the cursor up two lines
  if l:package !=# 'main'
    -2
  endif

endfunction
