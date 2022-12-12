local setlocal = vim.bo

-- Don't re-indent lines on right-angle-bracket or enter
setlocal.indentkeys:remove({ "<>>", "<Return>" })
vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "|setlocal indentkeys<"
