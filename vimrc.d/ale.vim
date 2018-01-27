let g:ale_fixers = {
      \ 'javascript': ['prettier_eslint', 'prettier', 'eslint', 'trim_whitespace', 'remove_trailing_lines'],
      \ 'json': ['prettier', 'fixjson', 'jq'],
      \ 'scss': ['prettier', 'stylelint'],
      \ 'css': ['prettier', 'stylelint'],
      \ 'less': ['prettier', 'stylelint'],
      \ 'stylus': ['stylelint'],
      \ 'c': ['clang-format'],
      \ 'cpp': ['clang-format'],
      \ 'rust': ['rustfmt'],
      \ 'python': ['autopep8', 'yapf', 'isort'],
      \ 'sh': ['shfmt'],
      \ 'markdown': ['prettier'],
      \ 'java': ['google_java_format']}
let g:ale_completion_enabled = 1
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" alt k & j to jump through errors
nmap <silent> <M-k> <Plug>(ale_previous_wrap)
nmap <silent> <M-j> <Plug>(ale_next_wrap)

" Disable for minified code
let g:ale_pattern_options = {
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\}

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
