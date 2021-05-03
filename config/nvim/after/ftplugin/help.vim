" Extra configuration for Vim help files
if &filetype !=# 'help' || v:version < 700
  finish
endif

" This variable had the wrong name before Vim 7.1
if v:version == 700 && exists('b:undo_plugin')
  let b:undo_ftplugin = b:undo_plugin
  unlet b:undo_plugin
endif

" If the buffer is modifiable and writable, we're writing documentation, not
" reading it; don't conceal characters
if has('conceal') && &modifiable && !&readonly
  setlocal conceallevel=0
  let b:undo_ftplugin .= '|setlocal conceallevel<'
endif

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_help_maps')
  finish
endif

" Make K jump to the help topic; NeoVim does this, and it's a damned good idea
if !has('nvim')
  nnoremap <buffer> K <C-]>
  let b:undo_ftplugin .= '|nunmap <buffer> K'
endif
