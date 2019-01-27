" Extra configuration for Vim scripts
if &filetype !=# 'vim' || v:version < 700 || &compatible
  finish
endif

" Use Vint as a syntax checker
if bufname('%') !=# 'command-line'
  compiler vint
  let b:undo_ftplugin .= '|unlet b:current_compiler'
        \ . '|setlocal errorformat< makeprg<'
endif

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_vim_maps')
  finish
endif

" ,K runs :helpgrep on the word under the cursor
nnoremap <buffer> <LocalLeader>K
      \ :<C-U>helpgrep <cword><CR>
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>K'

" Get rid of the core ftplugin's square-bracket maps on unload
" 8.1.273 updated the runtime files to include a fix for this
if v:version < 801 || v:version == 801 && !has('patch273')
  let b:undo_ftplugin .= '|nunmap <buffer> [['
      \ . '|vunmap <buffer> [['
      \ . '|nunmap <buffer> ]]'
      \ . '|vunmap <buffer> ]]'
      \ . '|nunmap <buffer> []'
      \ . '|vunmap <buffer> []'
      \ . '|nunmap <buffer> ]['
      \ . '|vunmap <buffer> ]['
      \ . '|nunmap <buffer> ]"'
      \ . '|vunmap <buffer> ]"'
      \ . '|nunmap <buffer> ["'
      \ . '|vunmap <buffer> ["'
endif
