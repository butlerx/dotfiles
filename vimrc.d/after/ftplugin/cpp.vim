" Extra configuration for C++ files
if &filetype !=# 'cpp' || v:version < 700
  finish
endif

" Include macros in completion
setlocal complete+=d

" Set include pattern
setlocal include=^\\s*#\\s*include

" Include headers on UNIX
if has('unix')
  setlocal path+=/usr/include
endif

let b:undo_ftplugin .= '|setlocal complete< include< path<'
