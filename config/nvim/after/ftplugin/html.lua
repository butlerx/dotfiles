-- Extra configuration for HTML files

-- Use tidy(1) for checking and program formatting
vim.cmd('compiler tidy')
vim.opt_local.equalprg = 'tidy -quiet'
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|unlet b:current_compiler'
  .. '|setlocal equalprg< errorformat< makeprg<'

-- Set up hooks for timestamp updating
local group = vim.api.nvim_create_augroup('html_timestamp', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = group,
  buffer = 0,
  callback = function()
    if vim.b.html_timestamp_check ~= nil then
      require('autoload.html').timestamp_update()
    end
  end,
})

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. "|execute 'autocmd! html_timestamp'"
  .. '|augroup! html_timestamp'

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_html_maps then
  return
end

-- Transform URLs to HTML anchors
vim.keymap.set('n', '<LocalLeader>r', function()
  require('autoload.html').url_link()
end, { buffer = true, silent = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|nunmap <buffer> <LocalLeader>r'
