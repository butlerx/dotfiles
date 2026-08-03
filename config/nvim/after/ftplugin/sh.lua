-- Extra configuration for shell script

-- Set comment formats
vim.opt_local.comments = ':#'
vim.cmd('setlocal formatoptions+=or')
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal comments< formatoptions<'

-- Dialect from the shebang, not from b:is_bash & co: those are still unset at
-- FileType time. See lua/autoload/sh.lua.
local dialect = require('autoload.sh').dialect(0)

-- If subtype is Bash, set 'keywordprg' to han(1df)
if dialect == 'bash' then
  vim.opt_local.keywordprg = 'han'
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal keywordprg<'
end

-- Choose check compiler based on file subtype
vim.b.sh_check_compiler = dialect

vim.cmd('compiler ' .. vim.b.sh_check_compiler)
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|unlet b:current_compiler b:sh_check_compiler'
  .. '|setlocal errorformat< makeprg<'

if vim.b.is_posix and (vim.v.version < 800 or (vim.v.version == 800 and vim.fn.has('patch257') == 0)) then
  -- Resort to g:is_posix for correct syntax on older runtime files
  -- 8.1.257 updated the runtime files to include a fix for this
  vim.g.is_posix = 1
end

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_sh_maps then
  return
end

-- Mappings to choose compiler
vim.keymap.set('n', '<LocalLeader>c', function()
  vim.cmd('compiler ' .. vim.b.sh_check_compiler)
end, { buffer = true, silent = true })

vim.keymap.set('n', '<LocalLeader>l', function()
  vim.cmd('compiler shellcheck')
end, { buffer = true, silent = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> <LocalLeader>c'
  .. '|nunmap <buffer> <LocalLeader>l'
