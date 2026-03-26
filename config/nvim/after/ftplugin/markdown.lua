-- Extra configuration for Markdown documents

-- Spellchecking features
if vim.fn.has('spell') == 1 then
  -- Spellcheck documents we're actually editing (not just viewing)
  if vim.bo.modifiable and not vim.bo.readonly then
    vim.opt_local.spell = true
    vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal spell<'
  end

  -- Tolerate leading lowercase letters in README.md files, for things like
  -- headings being filenames
  if vim.fn.expand('%:t') == 'README.md' then
    vim.opt_local.spellcapcheck = ''
    vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal spellcapcheck<'
  end
end

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_markdown_maps then
  return
end

-- Quote operator
vim.keymap.set('n', '<LocalLeader>q', function()
  return require('autoload.quote').quote()
end, { buffer = true, expr = true })

vim.keymap.set('n', '<LocalLeader>qq', function()
  return require('autoload.quote').quote() .. '_'
end, { buffer = true, expr = true })

vim.keymap.set('x', '<LocalLeader>q', function()
  return require('autoload.quote').quote()
end, { buffer = true, expr = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> <LocalLeader>q'
  .. '|nunmap <buffer> <LocalLeader>qq'
  .. '|xunmap <buffer> <LocalLeader>q'

-- Quote operator with reformatting
vim.keymap.set('n', '<LocalLeader>Q', function()
  return require('autoload.quote').quote_reformat()
end, { buffer = true, expr = true })

vim.keymap.set('n', '<LocalLeader>QQ', function()
  return require('autoload.quote').quote_reformat() .. '_'
end, { buffer = true, expr = true })

vim.keymap.set('x', '<LocalLeader>Q', function()
  return require('autoload.quote').quote_reformat()
end, { buffer = true, expr = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> <LocalLeader>Q'
  .. '|nunmap <buffer> <LocalLeader>QQ'
  .. '|xunmap <buffer> <LocalLeader>Q'
