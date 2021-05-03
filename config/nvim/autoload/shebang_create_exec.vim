" If the buffer starts with a shebang and the file being saved to doesn't
" exist yet, set up a hook to make it executable after the write is done
function! shebang_create_exec#Check(filename) abort
  if stridx(getline(1), '#!') == 0 && !filereadable(a:filename)
    autocmd shebang_create_exec BufWritePost <buffer>
          \ call shebang_create_exec#Chmod(expand('<afile>:p'))
  endif
endfunction

" Make the file executable and clear away the hook that called us
function! shebang_create_exec#Chmod(filename) abort
  autocmd! shebang_create_exec BufWritePost <buffer>
  call system('chmod +x '.shellescape(a:filename))
endfunction
