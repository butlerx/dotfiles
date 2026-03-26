-- Only do this when not yet done for this buffer
if vim.b.did_ftplugin then
  return
end

-- Set comment formats
vim.opt_local.comments = ':#'
vim.cmd('setlocal formatoptions+=or')
vim.b.undo_ftplugin = 'setlocal comments< formatoptions<'
