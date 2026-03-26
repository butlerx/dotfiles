-- Extra configuration for Perl filetypes

-- Use Perl itself for checking and Perl::Tidy for tidying
vim.cmd('compiler perl')
vim.opt_local.equalprg = 'perltidy'
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|unlet b:current_compiler'
  .. '|setlocal equalprg< errorformat< makeprg<'

-- Add angle brackets to pairs of matched characters for q<...>
vim.cmd('setlocal matchpairs+=<:>')
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal matchpairs<'

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_perl_maps then
  return
end

-- Add boilerplate intelligently
vim.keymap.set('n', '<LocalLeader>b', function()
  require('autoload.perl').boilerplate()
end, { buffer = true, silent = true })
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|nunmap <buffer> <LocalLeader>b'

-- Mappings to choose compiler
vim.keymap.set('n', '<LocalLeader>c', function()
  vim.cmd('compiler perl')
end, { buffer = true, silent = true })

vim.keymap.set('n', '<LocalLeader>l', function()
  vim.cmd('compiler perlcritic')
end, { buffer = true, silent = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> <LocalLeader>c'
  .. '|nunmap <buffer> <LocalLeader>l'

-- Bump version numbers
vim.keymap.set('n', '<LocalLeader>v', '<Plug>(PerlVersionBumpMinor)', { buffer = true, remap = true })
vim.keymap.set('n', '<LocalLeader>V', '<Plug>(PerlVersionBumpMajor)', { buffer = true, remap = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> <LocalLeader>v'
  .. '|nunmap <buffer> <LocalLeader>V'
