" Highlight white space at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
match ExtraWhitespace /\s\+$/
augroup Whitespace
  au!
  au BufWinEnter * match ExtraWhitespace /\s\+$/
  au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  au InsertLeave * match ExtraWhitespace /\s\+$/
  au BufWinLeave * call clearmatches()
augroup END
