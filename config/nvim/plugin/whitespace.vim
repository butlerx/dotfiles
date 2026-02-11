" Highlight white space at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
augroup Whitespace
  au!
  au BufWinEnter * if &filetype != 'neo-tree' | match ExtraWhitespace /\s\+$/ | endif
  au InsertEnter * if &filetype != 'neo-tree' | match ExtraWhitespace /\s\+\%#\@<!$/ | endif
  au InsertLeave * if &filetype != 'neo-tree' | match ExtraWhitespace /\s\+$/ | endif
  au BufWinLeave * call clearmatches()
augroup END
