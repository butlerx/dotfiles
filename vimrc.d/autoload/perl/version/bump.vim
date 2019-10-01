" Version number specifier format
if exists('g:perl#version#bump#pattern')
  let s:pattern = g:perl#version#bump#pattern
else
  let s:pattern = '\m\C^'
        \ . '\(our\s\+\$VERSION\s*=\D*\)'
        \ . '\(\d\+\)\.\(\d\+\)'
        \ . '\(.*\)'
endif

" Helper function to format a number without decreasing its digit count
function! s:Format(old, new) abort
  return repeat('0', strlen(a:old) - strlen(a:new)).a:new
endfunction

" Version number bumper
function! s:Bump(major) abort
  let l:view = winsaveview()
  let l:li = search(s:pattern)
  if !l:li
    echomsg 'No version number declaration found'
    return
  endif
  let l:matches = matchlist(getline(l:li), s:pattern)
  let [l:lvalue, l:major, l:minor, l:rest]
        \ = matchlist(getline(l:li), s:pattern)[1:4]
  if a:major
    let l:major = s:Format(l:major, l:major + 1)
    let l:minor = s:Format(l:minor, 0)
  else
    let l:minor = s:Format(l:minor, l:minor + 1)
  endif
  let l:version = l:major.'.'.l:minor
  call setline(l:li, l:lvalue.l:version.l:rest)
  if a:major
    echomsg 'Bumped major $VERSION: '.l:version
  else
    echomsg 'Bumped minor $VERSION: '.l:version
  endif
  call winrestview(l:view)
endfunction

" Autoloaded interface functions
function! perl#version#bump#Major() abort
  call s:Bump(1)
endfunction
function! perl#version#bump#Minor() abort
  call s:Bump(0)
endfunction
