" Only do this when not yet done for this buffer
if exists('b:did_ftplugin')
  finish
endif

" No autoformatting, literal tabs
setlocal noautoindent
setlocal noexpandtab
setlocal formatoptions=
let b:undo_ftplugin = 'setlocal autoindent< expandtab< formatoptions<'
