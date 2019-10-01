" Extra configuration for diffs
if &filetype !=# 'diff' || v:version < 700 || &compatible
  finish
endif

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_diff_maps')
  finish
endif

" Maps using autoloaded function for quoted block movement
nnoremap <buffer> <silent> <LocalLeader>[
      \ :<C-U>call diff#MoveBlock(v:count1, 1, 0)<CR>
nnoremap <buffer> <silent> <LocalLeader>]
      \ :<C-U>call diff#MoveBlock(v:count1, 0, 0)<CR>
onoremap <buffer> <silent> <LocalLeader>[
      \ :<C-U>call diff#MoveBlock(v:count1, 1, 0)<CR>
onoremap <buffer> <silent> <LocalLeader>]
      \ :<C-U>call diff#MoveBlock(v:count1, 0, 0)<CR>
xnoremap <buffer> <silent> <LocalLeader>[
      \ :<C-U>call diff#MoveBlock(v:count1, 1, 1)<CR>
xnoremap <buffer> <silent> <LocalLeader>]
      \ :<C-U>call diff#MoveBlock(v:count1, 0, 1)<CR>
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>['
      \ . '|nunmap <buffer> <LocalLeader>]'
      \ . '|ounmap <buffer> <LocalLeader>['
      \ . '|ounmap <buffer> <LocalLeader>]'
      \ . '|xunmap <buffer> <LocalLeader>['
      \ . '|xunmap <buffer> <LocalLeader>]'

" Set mappings
nmap <buffer> <LocalLeader>p
      \ <Plug>(DiffPrune)
xmap <buffer> <LocalLeader>p
      \ <Plug>(DiffPrune)
nmap <buffer> <LocalLeader>pp
      \ <Plug>(DiffPrune)_
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>p'
      \ . '|xunmap <buffer> <LocalLeader>p'
      \ . '|nunmap <buffer> <LocalLeader>pp'
