local setlocal = vim.bo
-- Observe VimL conventions for two-space indents
setlocal.shiftwidth = 2
setlocal.softtabstop = -1

-- Remove inapplicable defaults from 'indentkeys'
-- setlocal.indentkeys:remove { "0#", "0{", "0}", "0)", ":" }
vim.cmd [[
    setlocal indentkeys-=0#
    setlocal indentkeys-=0{
    setlocal indentkeys-=0}
    setlocal indentkeys-=0)
    setlocal indentkeys-=:
]]

-- Comma  nds to undo the above
if vim.b.undo_indent then
    vim.b.undo_indent = vim.b.undo_indent .. "|setlocal shiftwidth<" .. "|setlocal softtabstop<"
end
