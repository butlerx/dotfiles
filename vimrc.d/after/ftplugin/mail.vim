" Extra configuration for mail messages
if &filetype !=# 'mail' || &compatible || v:version < 700
  finish
endif

" If something hasn't already moved the cursor, we'll move to an optimal point
" to start writing
if line('.') == 1 && col('.') == 1

  " Start by trying to move to the first quoted line; this may fail if there's
  " no quote, which is fine
  call search('\m^>', 'c')

  " Check this line to see if it's a generic hello-name greeting that we can
  " just strip out; delete any following lines too, if they're blank
  if getline('.') =~? '^>\s*\%(<hello\|hey\+\|hi\)\s\+\S\+\s*$'
    delete
    while getline('.') =~# '^>$'
      delete
    endwhile
  endif

  " Now move to the first quoted or unquoted blank line
  call search('\m^>\=$', 'c')

endif

" Add a space to the end of wrapped lines for format-flowed mail
setlocal formatoptions+=w
let b:undo_ftplugin .= '|setlocal formatoptions<'

" Define what constitutes a 'blank line' for the squeeze_repeat_blanks.vim
" plugin, if loaded, to include leading quotes and spaces
if exists('g:loaded_squeeze_repeat_blanks')
  let b:squeeze_repeat_blanks_blank = '^[ >]*$'
  let b:undo_ftplugin .= '|unlet b:squeeze_repeat_blanks_blank'
endif

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_mail_maps')
  finish
endif

" Flag messages as important/unimportant
nnoremap <buffer> <LocalLeader>h
      \ <C-U>:call mail#FlagImportant()<CR>
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>h'
nnoremap <buffer> <LocalLeader>l
      \ <C-U>:call mail#FlagUnimportant()<CR>
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>l'

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

" Maps using autoloaded function for quoted paragraph movement
nnoremap <buffer> <silent> <LocalLeader>[
      \ :<C-U>call mail#NewBlank(v:count1, 1, 0)<CR>
nnoremap <buffer> <silent> <LocalLeader>]
      \ :<C-U>call mail#NewBlank(v:count1, 0, 0)<CR>
onoremap <buffer> <silent> <LocalLeader>[
      \ :<C-U>call mail#NewBlank(v:count1, 1, 0)<CR>
onoremap <buffer> <silent> <LocalLeader>]
      \ :<C-U>call mail#NewBlank(v:count1, 0, 0)<CR>
xnoremap <buffer> <silent> <LocalLeader>[
      \ :<C-U>call mail#NewBlank(v:count1, 1, 1)<CR>
xnoremap <buffer> <silent> <LocalLeader>]
      \ :<C-U>call mail#NewBlank(v:count1, 0, 1)<CR>
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>['
      \ . '|nunmap <buffer> <LocalLeader>]'
      \ . '|ounmap <buffer> <LocalLeader>['
      \ . '|ounmap <buffer> <LocalLeader>]'
      \ . '|xunmap <buffer> <LocalLeader>['
      \ . '|xunmap <buffer> <LocalLeader>]'
