-- Extra configuration for diffs

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_diff_maps then
  return
end

-- Maps using autoloaded function for quoted block movement
vim.keymap.set('n', '<LocalLeader>[', function()
  require('autoload.diff').move_block(vim.v.count1, 1, 0)
end, { buffer = true, silent = true })

vim.keymap.set('n', '<LocalLeader>]', function()
  require('autoload.diff').move_block(vim.v.count1, 0, 0)
end, { buffer = true, silent = true })

vim.keymap.set('o', '<LocalLeader>[', function()
  require('autoload.diff').move_block(vim.v.count1, 1, 0)
end, { buffer = true, silent = true })

vim.keymap.set('o', '<LocalLeader>]', function()
  require('autoload.diff').move_block(vim.v.count1, 0, 0)
end, { buffer = true, silent = true })

vim.keymap.set('x', '<LocalLeader>[', function()
  require('autoload.diff').move_block(vim.v.count1, 1, 1)
end, { buffer = true, silent = true })

vim.keymap.set('x', '<LocalLeader>]', function()
  require('autoload.diff').move_block(vim.v.count1, 0, 1)
end, { buffer = true, silent = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> <LocalLeader>['
  .. '|nunmap <buffer> <LocalLeader>]'
  .. '|ounmap <buffer> <LocalLeader>['
  .. '|ounmap <buffer> <LocalLeader>]'
  .. '|xunmap <buffer> <LocalLeader>['
  .. '|xunmap <buffer> <LocalLeader>]'

-- Set mappings
vim.keymap.set('n', '<LocalLeader>p', '<Plug>(DiffPrune)', { buffer = true, remap = true })
vim.keymap.set('x', '<LocalLeader>p', '<Plug>(DiffPrune)', { buffer = true, remap = true })
vim.keymap.set('n', '<LocalLeader>pp', '<Plug>(DiffPrune)_', { buffer = true, remap = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> <LocalLeader>p'
  .. '|xunmap <buffer> <LocalLeader>p'
  .. '|nunmap <buffer> <LocalLeader>pp'
