-- Extra configuration for PHP scripts

-- Use PHP itself for syntax checking
vim.cmd('compiler php')
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|unlet b:current_compiler'
  .. '|setlocal errorformat< makeprg<'

-- Set comment formats
vim.opt_local.comments = 's1:/*,m:*,ex:*/,://,:#'
vim.cmd('setlocal formatoptions+=or')
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal comments< formatoptions<'

-- Use pman as 'keywordprg'
vim.opt_local.keywordprg = 'pman'
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal keywordprg<'

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_php_maps then
  return
end

-- Get rid of the core ftplugin's square-bracket maps on unload
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> [['
  .. '|ounmap <buffer> [['
  .. '|nunmap <buffer> ]]'
  .. '|ounmap <buffer> ]]'
