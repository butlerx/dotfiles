-- Extra configuration for Git commit messages

-- Make angle brackets behave like mail quotes
vim.cmd('setlocal comments+=n:>')
vim.cmd('setlocal formatoptions+=coqr')
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal comments< formatoptions<'

-- Choose the color column depending on non-comment line count
if vim.fn.exists('+cursorcolumn') == 1 then
  local group = vim.api.nvim_create_augroup('gitcommit', { clear = true })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = group,
    buffer = 0,
    callback = function()
      vim.opt_local.colorcolumn = require('autoload.gitcommit').cursor_column()
    end,
  })

  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
    .. '|autocmd! gitcommit'
    .. "|execute 'autocmd! gitcommit'"
    .. '|setlocal colorcolumn<'
end

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_gitcommit_maps then
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
