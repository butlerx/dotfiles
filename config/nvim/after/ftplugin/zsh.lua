-- Extra configuration for Z shell scripts

-- Use Z shell itself as a syntax checker
vim.cmd('compiler zsh')
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|unlet b:current_compiler'
  .. '|setlocal errorformat< makeprg<'
