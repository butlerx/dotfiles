let g:ale_fixers = {
  \ 'javascript': ['prettier_eslint', 'prettier', 'eslint', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'json': ['prettier', 'fixjson', 'jq',  'trim_whitespace', 'remove_trailing_lines'],
  \ 'scss': ['prettier', 'stylelint', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'css': ['prettier', 'stylelint', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'less': ['prettier', 'stylelint', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'stylus': ['stylelint', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'c': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'cpp': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'python': ['autopep8', 'yapf', 'isort', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'zsh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'sh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'go': ['gofmt', 'goimports', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'markdown': ['prettier'],
  \ 'vue': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
  \ 'java': ['google_java_format', 'trim_whitespace', 'remove_trailing_lines']}
let g:ale_fix_on_save = 1
let g:ale_go_gofmt_options = '-s'
let g:ale_go_gometalinter_options = '--enable=gosimple --enable=staticcheck'
let g:ale_linters = { 'javascript': ['eslint', 'flow'], 'go': ['gometalinter', 'gobuild'], 'zsh':['shell', 'shellcheck']}
let g:ale_completion_enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %code: %%s '

" alt k & j to jump through errors
nmap <silent> <M-k> <Plug>(ale_previous_wrap)
nmap <silent> <M-j> <Plug>(ale_next_wrap)

" Disable for minified code and enable whitespace trimming
let g:ale_pattern_options = {
  \ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
  \ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []}}",
  "\ '\.*': {'ale_fixers': ['trim_whitespace', 'remove_trailing_lines']}}

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
"let g:ale_open_list = 1
"
