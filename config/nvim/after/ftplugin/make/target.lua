-- make/target.vim: Provide a mapping to :make the target for the recipe under
-- the cursor.

-- Don't load if running compatible or too old
-- Don't load if already loaded
if vim.b.did_ftplugin_make_target then
  return
end

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_make_maps then
  return
end

-- Flag as loaded
vim.b.did_ftplugin_make_target = 1
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|unlet b:did_ftplugin_make_target'

-- Define normal mode mapping target
vim.keymap.set('n', '<Plug>(MakeTarget)', function()
  require('autoload.make.target').make()
end, { buffer = true, silent = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|nunmap <buffer> <Plug>(MakeTarget)'
