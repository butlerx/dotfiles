" make/target.vim: Provide a mapping to :make the target for the recipe under
" the cursor.

" Don't load if running compatible or too old
if &compatible || v:version < 700
  finish
endif

" Don't load if already loaded
if exists('b:did_ftplugin_make_target')
  finish
endif

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_make_maps')
  finish
endif

" Flag as loaded
let b:did_ftplugin_make_target = 1
let b:undo_ftplugin = b:undo_ftplugin
      \ . '|unlet b:did_ftplugin_make_target'

" Define normal mode mapping target
nnoremap <buffer> <silent> <unique>
      \ <Plug>(MakeTarget)
      \ :<C-U>call make#target#Make()<CR>
let b:undo_ftplugin = b:undo_ftplugin
      \ . '|nunmap <buffer> <Plug>(MakeTarget)'
