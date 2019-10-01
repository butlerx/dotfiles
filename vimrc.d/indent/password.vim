" Only do this when not done yet for this buffer
if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

" Manual indenting and literal tabs for passwords
setlocal noautoindent
setlocal noexpandtab
setlocal softtabstop=0
let b:undo_indent = 'setlocal autoindent< expandtab< softtabstop<'
