" perl/version_bump.vim: Mapping targets to bump Perl package version numbers.

" Don't load if running compatible or too old
if &compatible || v:version < 700
  finish
endif

" Don't load if already loaded
if exists('b:did_ftplugin_perl_version_bump')
  finish
endif

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_perl_maps')
  finish
endif

" Flag as loaded
let b:did_ftplugin_perl_version_bump = 1
let b:undo_ftplugin = b:undo_ftplugin
      \ . '|unlet b:did_ftplugin_perl_version_bump'

" Bump version numbers
nnoremap <buffer> <silent> <unique>
      \ <Plug>(PerlVersionBumpMajor)
      \ :<C-U>call perl#version#bump#Major()<CR>
nnoremap <buffer> <silent> <unique>
      \ <Plug>(PerlVersionBumpMinor)
      \ :<C-U>call perl#version#bump#Minor()<CR>
let b:undo_ftplugin = b:undo_ftplugin
      \ . '|nunmap <buffer> <Plug>(PerlVersionBumpMajor)'
      \ . '|nunmap <buffer> <Plug>(PerlVersionBumpMinor)'
