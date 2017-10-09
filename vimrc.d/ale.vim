let g:ale_fixers = { 'javascript': ['prettier_eslint'], 'json': ['prettier'], 'scss': ['prettier'], 'css': ['prettier'], 'less': ['prettier'], 'python': ['autopep8', 'yapf', 'isort']}
let g:ale_linters = { 'javascript': ['eslint', 'flow'] }
let g:ale_fix_on_save = 1
let g:ale_fix_on_enter = 1
let g:ale_fix_on_insert_leave = 1
let g:ale_fix_on_text_changed = 1
let g:ale_javascript_prettier_eslint_options = '--single-quote --trailing-comma es5 --print-width 100'
