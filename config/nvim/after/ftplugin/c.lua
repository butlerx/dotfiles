-- Extra configuration for C files

-- Include macros in completion
vim.cmd('setlocal complete+=d')
-- Set include pattern
vim.opt_local.include = [[^\s*#\s*include]]

-- Include headers on UNIX
if vim.fn.has('unix') == 1 then
  vim.cmd('setlocal path+=/usr/include')
end

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal complete< include< path<'
