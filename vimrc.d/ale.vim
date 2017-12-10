let g:ale_fixers = {
      \ 'javascript': ['prettier_eslint', 'prettier', 'eslint', 'trim_whitespace', 'remove_trailing_lines'],
      \ 'json': ['prettier'],
      \ 'scss': ['prettier'],
      \ 'css': ['prettier'],
      \ 'less': ['prettier'],
      \ 'python': ['autopep8', 'yapf', 'isort'],
      \ 'sh': ['shfmt'],
      \ 'java': ['google-java-format']}
let g:ale_completion_enabled = 1
let g:ale_javascript_prettier_eslint_options = '--single-quote --trailing-comma es5 --print-width 100'
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5 --print-width 100'
