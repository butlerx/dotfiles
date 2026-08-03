-- Don't re-indent lines on right-angle-bracket or enter. Must be vim.opt_local,
-- not vim.bo: vim.bo returns 'indentkeys' as a plain string, which has no
-- :remove. b:undo_indent already carries 'indk<' from the base html indent
-- script, so no undo bookkeeping is needed here.
vim.opt_local.indentkeys:remove({ "<>>", "<Return>" })
