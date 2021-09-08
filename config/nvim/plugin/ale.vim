let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'typescript': ['prettier', 'tslint', 'eslint'],
  \ 'typescriptreact': ['prettier', 'tslint', 'eslint'],
  \ 'html': ['eslint'],
  \ 'json': ['prettier', 'fixjson', 'jq'],
  \ 'scss': ['prettier', 'stylelint'],
  \ 'css': ['prettier', 'stylelint'],
  \ 'less': ['prettier', 'stylelint'],
  \ 'stylus': ['stylelint',],
  \ 'c': ['clang-format'],
  \ 'cpp': ['clang-format'],
  \ 'rust': ['rustfmt'],
  \ 'python': ['yapf', 'isort', 'black'],
  \ 'zsh': ['shfmt'],
  \ 'sh': ['shfmt'],
  \ 'go': ['gofmt', 'goimports'],
  \ 'markdown': ['prettier'],
  \ 'vimwiki': ['prettier'],
  \ 'vue': ['prettier'],
  \ 'yaml': ['prettier'],
  \ 'ansible': ['prettier'],
  \ 'puppet': ['puppetlint'],
  \ 'java': ['google_java_format']}
let g:ale_fix_on_save = 1
let g:ale_go_gofmt_options = '-s'
let g:ale_go_gometalinter_options = '--fast'
let g:ale_go_golangci_lint_options = '--fast'
let g:ale_go_golangci_lint_package = 1
let g:ale_rust_cargo_use_clippy = 1
let g:ale_rust_analyzer_config = {
  \'rust-analyzer': {
  \ 'assist': {
  \   'importMergeBehavior': 'last',
  \   'importPrefix': 'by_self',
  \ },
  \ 'cargo.loadOutDirsFromCheck': v:true,
  \ 'procMacro.enable': v:true }}
let g:ale_linters = {
  \ 'go': ['golangci-lint', 'gobuild', 'golint'],
  \ 'rust': ['cargo', 'rls'],
  \ 'typescript': ['tslint', 'tsserver', 'typecheck']}
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
  \ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
  \ '*': {'ale_fixers': ['trim_whitespace', 'remove_trailing_lines']}}

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
command! ALEToggleFixer execute "let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0) ? 0 : 1"
"let g:ale_open_list = 1
