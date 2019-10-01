" Only do this when not yet done for this buffer
if exists('b:did_ftplugin')
  finish
endif

" Set comment formats
setlocal comments=:#
setlocal formatoptions+=or
let b:undo_ftplugin = 'setlocal comments< formatoptions<'
