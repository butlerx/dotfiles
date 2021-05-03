" Extra configuration for Makefiles
if &filetype !=# 'make' || v:version < 700
  finish
endif

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_make_maps')
  finish
endif

" Set mappings
nmap <buffer> <LocalLeader>m <Plug>(MakeTarget)
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>m'
