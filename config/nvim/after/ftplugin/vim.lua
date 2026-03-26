-- Extra configuration for Vim scripts

-- Use Vint as a syntax checker
if vim.fn.bufname('%') ~= 'command-line' then
  vim.cmd('compiler vint')
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
    .. '|unlet b:current_compiler'
    .. '|setlocal errorformat< makeprg<'
end

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_vim_maps then
  return
end

-- ,K runs :helpgrep on the word under the cursor
vim.keymap.set('n', '<LocalLeader>K', function()
  vim.cmd('helpgrep ' .. vim.fn.expand('<cword>'))
end, { buffer = true, silent = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|nunmap <buffer> <LocalLeader>K'

-- Get rid of the core ftplugin's square-bracket maps on unload
-- 8.1.273 updated the runtime files to include a fix for this
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> [['
  .. '|vunmap <buffer> [['
  .. '|nunmap <buffer> ]]'
  .. '|vunmap <buffer> ]]'
  .. '|nunmap <buffer> []'
  .. '|vunmap <buffer> []'
  .. '|nunmap <buffer> ]['
  .. '|vunmap <buffer> ]['
  .. '|nunmap <buffer> ]"'
  .. '|vunmap <buffer> ]"'
  .. '|nunmap <buffer> ["'
  .. '|vunmap <buffer> ["'
