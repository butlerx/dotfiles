-- Extra configuration for Vim help files

-- This variable had the wrong name before Vim 7.1
if vim.v.version == 700 and vim.b.undo_plugin then
  vim.b.undo_ftplugin = vim.b.undo_plugin
  vim.b.undo_plugin = nil
end

-- If the buffer is modifiable and writable, we're writing documentation, not
-- reading it; don't conceal characters
if vim.bo.modifiable and not vim.bo.readonly then
  vim.opt_local.conceallevel = 0
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal conceallevel<'
end

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_help_maps then
  return
end

-- Make K jump to the help topic; NeoVim does this, and it's a damned good idea
