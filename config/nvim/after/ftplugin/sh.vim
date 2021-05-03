" Extra configuration for shell script
if &filetype !=# 'sh' || v:version < 700 || &compatible
  finish
endif

" Set comment formats
setlocal comments=:#
setlocal formatoptions+=or
let b:undo_ftplugin .= '|setlocal comments< formatoptions<'

" If subtype is Bash, set 'keywordprg' to han(1df)
if exists('b:is_bash')
  setlocal keywordprg=han
  let b:undo_ftplugin .= '|setlocal keywordprg<'
endif

" Choose check compiler based on file subtype
if exists('b:is_bash')
  let b:sh_check_compiler = 'bash'
elseif exists('b:is_kornshell')
  let b:sh_check_compiler = 'ksh'
else
  let b:sh_check_compiler = 'sh'
endif
execute 'compiler '.b:sh_check_compiler
let b:undo_ftplugin .= '|unlet b:current_compiler b:sh_check_compiler'
      \ . '|setlocal errorformat< makeprg<'

" Resort to g:is_posix for correct syntax on older runtime files
" 8.1.257 updated the runtime files to include a fix for this
if exists('b:is_posix')
      \ && (v:version < 800 || v:version == 800 && !has('patch257'))
  let g:is_posix = 1
endif

" Stop here if the user doesn't want ftplugin mappings
if exists('g:no_plugin_maps') || exists('g:no_sh_maps')
  finish
endif

" Mappings to choose compiler
nnoremap <buffer> <expr> <LocalLeader>c
      \ ':<C-U>compiler '.b:sh_check_compiler.'<CR>'
nnoremap <buffer> <LocalLeader>l
      \ :<C-U>compiler shellcheck<CR>
let b:undo_ftplugin .= '|nunmap <buffer> <LocalLeader>c'
      \ . '|nunmap <buffer> <LocalLeader>l'
