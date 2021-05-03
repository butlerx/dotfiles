" Extra configuration for PHP scripts
if &filetype !=# 'php' || v:version < 700 || &compatible
  finish
endif

" Use PHP itself for syntax checking
compiler php
let b:undo_ftplugin .= '|unlet b:current_compiler'
      \ . '|setlocal errorformat< makeprg<'

" Set comment formats
setlocal comments=s1:/*,m:*,ex:*/,://,:#
setlocal formatoptions+=or
let b:undo_ftplugin .= '|setlocal comments< formatoptions<'

" Use pman as 'keywordprg'
setlocal keywordprg=pman
let b:undo_ftplugin .= '|setlocal keywordprg<'

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_php_maps')
  finish
endif

" Get rid of the core ftplugin's square-bracket maps on unload
let b:undo_ftplugin .= '|nunmap <buffer> [['
      \ . '|ounmap <buffer> [['
      \ . '|nunmap <buffer> ]]'
      \ . '|ounmap <buffer> ]]'
