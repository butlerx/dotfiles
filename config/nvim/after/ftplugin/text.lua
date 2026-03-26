-- Extra configuration for text files

-- Spellcheck documents we're actually editing (not just viewing)
if vim.fn.has('spell') == 1 and vim.bo.modifiable and not vim.bo.readonly then
  vim.opt_local.spell = true
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal spell<'
end
