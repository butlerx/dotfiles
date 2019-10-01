" Extra configuration for Z shell scripts
if &filetype !=# 'zsh' || v:version < 700 || &compatible
  finish
endif

" Use Z shell itself as a syntax checker
compiler zsh
let b:undo_ftplugin .= '|unlet b:current_compiler'
      \ . '|setlocal errorformat< makeprg<'
