-- diff/prune.vim: Provide a mapping to remove blocks of a diff buffer.

-- Don't load if running compatible or too old
-- Don't load if already loaded
if vim.b.did_ftplugin_diff_prune then
  return
end

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_diff_maps then
  return
end

-- Flag as loaded
vim.b.did_ftplugin_diff_prune = 1
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|unlet b:did_ftplugin_diff_prune'

-- Define normal mode mapping target
vim.keymap.set('n', '<Plug>(DiffPrune)', function()
  vim.go.operatorfunc = "v:lua.require'autoload.diff.prune'.prune"
  return 'g@'
end, { buffer = true, silent = true, expr = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|nunmap <buffer> <Plug>(DiffPrune)'

-- Define visual mode mapping target
vim.keymap.set('x', '<Plug>(DiffPrune)', function()
  require('autoload.diff.prune').prune(vim.fn.visualmode())
end, { buffer = true, silent = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|xunmap <buffer> <Plug>(DiffPrune)'
