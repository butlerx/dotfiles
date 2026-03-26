-- Extra configuration for mail messages

-- If something hasn't already moved the cursor, we'll move to an optimal point
-- to start writing
if vim.fn.line('.') == 1 and vim.fn.col('.') == 1 then
  -- Start by trying to move to the first quoted line; this may fail if there's
  -- no quote, which is fine
  vim.fn.search('\\m^>', 'c')

  -- Check this line to see if it's a generic hello-name greeting that we can
  -- just strip out; delete any following lines too, if they're blank
  if vim.fn.match(vim.fn.getline('.'), [[\c^>\s*\%(<hello\|hey\+\|hi\)\s\+\S\+\s*$]]) >= 0 then
    vim.cmd('delete')
    while vim.fn.match(vim.fn.getline('.'), [[^>$]]) >= 0 do
      vim.cmd('delete')
    end
  end

  -- Now move to the first quoted or unquoted blank line
  vim.fn.search('\\m^>\\=$', 'c')
end

-- Add a space to the end of wrapped lines for format-flowed mail
vim.cmd('setlocal formatoptions+=w')
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal formatoptions<'

-- Define what constitutes a 'blank line' for the squeeze_repeat_blanks.vim
-- plugin, if loaded, to include leading quotes and spaces
if vim.g.loaded_squeeze_repeat_blanks ~= nil then
  vim.b.squeeze_repeat_blanks_blank = '^[ >]*$'
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|unlet b:squeeze_repeat_blanks_blank'
end

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_mail_maps then
  return
end

-- Flag messages as important/unimportant
vim.keymap.set('n', '<LocalLeader>h', function()
  require('autoload.mail').flag_important()
end, { buffer = true, silent = true })
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|nunmap <buffer> <LocalLeader>h'

vim.keymap.set('n', '<LocalLeader>l', function()
  require('autoload.mail').flag_unimportant()
end, { buffer = true, silent = true })
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|nunmap <buffer> <LocalLeader>l'

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

-- Maps using autoloaded function for quoted paragraph movement
vim.keymap.set('n', '<LocalLeader>[', function()
  require('autoload.mail').new_blank(vim.v.count1, 1, 0)
end, { buffer = true, silent = true })

vim.keymap.set('n', '<LocalLeader>]', function()
  require('autoload.mail').new_blank(vim.v.count1, 0, 0)
end, { buffer = true, silent = true })

vim.keymap.set('o', '<LocalLeader>[', function()
  require('autoload.mail').new_blank(vim.v.count1, 1, 0)
end, { buffer = true, silent = true })

vim.keymap.set('o', '<LocalLeader>]', function()
  require('autoload.mail').new_blank(vim.v.count1, 0, 0)
end, { buffer = true, silent = true })

vim.keymap.set('x', '<LocalLeader>[', function()
  require('autoload.mail').new_blank(vim.v.count1, 1, 1)
end, { buffer = true, silent = true })

vim.keymap.set('x', '<LocalLeader>]', function()
  require('autoload.mail').new_blank(vim.v.count1, 0, 1)
end, { buffer = true, silent = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> <LocalLeader>['
  .. '|nunmap <buffer> <LocalLeader>]'
  .. '|ounmap <buffer> <LocalLeader>['
  .. '|ounmap <buffer> <LocalLeader>]'
  .. '|xunmap <buffer> <LocalLeader>['
  .. '|xunmap <buffer> <LocalLeader>]'
