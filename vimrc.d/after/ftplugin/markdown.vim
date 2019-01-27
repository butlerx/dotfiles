" Extra configuration for Markdown documents
if &filetype !=# 'markdown' || v:version < 700
  finish
endif

" Spellchecking features
if has('spell')

  " Spellcheck documents we're actually editing (not just viewing)
  if &modifiable && !&readonly
    setlocal spell
    let b:undo_ftplugin .= '|setlocal spell<'
  endif
  " Tolerate leading lowercase letters in README.md files, for things like
  " headings being filenames
  if expand('%:t') ==# 'README.md'
    setlocal spellcapcheck=
    let b:undo_ftplugin .= '|setlocal spellcapcheck<'
  endif

endif

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_markdown_maps')
  finish
endif

" Quote operator
nnoremap <buffer> <expr> <LocalLeader>q
      \ quote#Quote()
nnoremap <buffer> <expr> <LocalLeader>qq
      \ quote#Quote().'_'
xnoremap <buffer> <expr> <LocalLeader>q
      \ quote#Quote()
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>q'
      \ . '|nunmap <buffer> <LocalLeader>qq'
      \ . '|xunmap <buffer> <LocalLeader>q'

" Quote operator with reformatting
nnoremap <buffer> <expr> <LocalLeader>Q
      \ quote#QuoteReformat()
nnoremap <buffer> <expr> <LocalLeader>QQ
      \ quote#QuoteReformat().'_'
xnoremap <buffer> <expr> <LocalLeader>Q
      \ quote#QuoteReformat()
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>Q'
      \ . '|nunmap <buffer> <LocalLeader>QQ'
      \ . '|xunmap <buffer> <LocalLeader>Q'
