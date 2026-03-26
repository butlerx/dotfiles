-- Extra configuration for shell script

-- Set comment formats
vim.opt_local.comments = ':#'
vim.cmd('setlocal formatoptions+=or')
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal comments< formatoptions<'

-- If subtype is Bash, set 'keywordprg' to han(1df)
if vim.b.is_bash then
  vim.opt_local.keywordprg = 'han'
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal keywordprg<'
end

-- Choose check compiler based on file subtype
if vim.b.is_bash then
  vim.b.sh_check_compiler = 'bash'
elseif vim.b.is_kornshell then
  vim.b.sh_check_compiler = 'ksh'
else
  vim.b.sh_check_compiler = 'sh'
end

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
