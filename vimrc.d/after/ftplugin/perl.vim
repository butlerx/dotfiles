" Extra configuration for Perl filetypes
if &filetype !=# 'perl' || v:version < 700 || &compatible
  finish
endif

" Use Perl itself for checking and Perl::Tidy for tidying
compiler perl
setlocal equalprg=perltidy
let b:undo_ftplugin .= '|unlet b:current_compiler'
      \ . '|setlocal equalprg< errorformat< makeprg<'

" Add angle brackets to pairs of matched characters for q<...>
setlocal matchpairs+=<:>
let b:undo_ftplugin .= '|setlocal matchpairs<'

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_perl_maps')
  finish
endif

" Add boilerplate intelligently
nnoremap <buffer> <silent> <LocalLeader>b
      \ :<C-U>call perl#Boilerplate()<CR>
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>b'

" Mappings to choose compiler
nnoremap <buffer> <LocalLeader>c
      \ :<C-U>compiler perl<CR>
nnoremap <buffer> <LocalLeader>l
      \ :<C-U>compiler perlcritic<CR>
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>c'
      \ . '|nunmap <buffer> <LocalLeader>l'

" Bump version numbers
nmap <buffer> <LocalLeader>v
      \ <Plug>(PerlVersionBumpMinor)
nmap <buffer> <LocalLeader>V
      \ <Plug>(PerlVersionBumpMajor)
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>v'
      \ . '|nunmap <buffer> <LocalLeader>V'
