-- Extra configuration for Makefiles

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_make_maps then
  return
end

-- Set mappings
vim.keymap.set('n', '<LocalLeader>m', '<Plug>(MakeTarget)', { buffer = true, remap = true })
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|nunmap <buffer> <LocalLeader>m'
