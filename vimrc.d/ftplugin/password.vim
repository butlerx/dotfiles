" Only do this when not yet done for this buffer
if exists('b:did_ftplugin')
  finish
endif

" No autoformatting
setlocal formatoptions=
let b:undo_ftplugin = 'setlocal formatoptions<'
