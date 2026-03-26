-- perl/version_bump.vim: Mapping targets to bump Perl package version numbers.

-- Don't load if running compatible or too old
-- Don't load if already loaded
if vim.b.did_ftplugin_perl_version_bump then
  return
end

-- Stop here if the user doesn't want ftplugin mappings
if vim.g.no_plugin_maps or vim.g.no_perl_maps then
  return
end

-- Flag as loaded
vim.b.did_ftplugin_perl_version_bump = 1
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|unlet b:did_ftplugin_perl_version_bump'

-- Bump version numbers
vim.keymap.set('n', '<Plug>(PerlVersionBumpMajor)', function()
  require('autoload.perl.version.bump').major()
end, { buffer = true, silent = true })

vim.keymap.set('n', '<Plug>(PerlVersionBumpMinor)', function()
  require('autoload.perl.version.bump').minor()
end, { buffer = true, silent = true })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
  .. '|nunmap <buffer> <Plug>(PerlVersionBumpMajor)'
  .. '|nunmap <buffer> <Plug>(PerlVersionBumpMinor)'
