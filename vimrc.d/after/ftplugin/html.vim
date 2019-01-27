" Extra configuration for HTML files
if &filetype !=# 'html' || v:version < 700 || &compatible
  finish
endif

" Use tidy(1) for checking and program formatting
compiler tidy
setlocal equalprg=tidy\ -quiet
let b:undo_ftplugin .= '|unlet b:current_compiler'
      \ . '|setlocal equalprg< errorformat< makeprg<'

" Set up hooks for timestamp updating
augroup html_timestamp
  autocmd BufWritePre <buffer>
        \ if exists('b:html_timestamp_check')
        \|  call html#TimestampUpdate()
        \|endif
augroup END
let b:undo_ftplugin .= '|execute ''autocmd! html_timestamp'''
      \ . '|augroup! html_timestamp'

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_html_maps')
  finish
endif

" Transform URLs to HTML anchors
nnoremap <buffer> <LocalLeader>r
      \ :<C-U>call html#UrlLink()<CR>
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>r'
