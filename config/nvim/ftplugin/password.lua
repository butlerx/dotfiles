-- Only do this when not yet done for this buffer
if vim.b.did_ftplugin then
  return
end

-- No autoformatting
vim.opt_local.formatoptions = ''
vim.b.undo_ftplugin = 'setlocal formatoptions<'
