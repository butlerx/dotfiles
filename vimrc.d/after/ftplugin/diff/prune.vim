" diff/prune.vim: Provide a mapping to remove blocks of a diff buffer.

" Don't load if running compatible or too old
if &compatible || v:version < 700
  finish
endif

" Don't load if already loaded
if exists('b:did_ftplugin_diff_prune')
  finish
endif

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_diff_maps')
  finish
endif

" Flag as loaded
let b:did_ftplugin_diff_prune = 1
let b:undo_ftplugin .= '|unlet b:did_ftplugin_diff_prune'

" Define normal mode mapping target
nnoremap <buffer> <silent> <unique>
      \ <Plug>(DiffPrune)
      \ :<C-U>set operatorfunc=diff#prune#Prune<CR>g@
let b:undo_ftplugin .= '|nunmap <buffer> <Plug>(DiffPrune)'

" Define visual mode mapping target
xnoremap <buffer> <silent> <unique>
      \ <Plug>(DiffPrune)
      \ :<C-U>call diff#prune#Prune(visualmode())<CR>
let b:undo_ftplugin .= '|xunmap <buffer> <Plug>(DiffPrune)'
