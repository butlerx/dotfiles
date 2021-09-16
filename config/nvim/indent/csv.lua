local setlocal = vim.bo
-- Only do this when not done yet for this buffer
if vim.b.did_indent then
    return
end
vim.b.did_indent = 1

-- Manual indenting and literal tabs for CSVs
setlocal.autoindent = false
setlocal.expandtab = false
setlocal.softtabstop = 0
vim.b.undo_indent = "setlocal autoindent< expandtab< softtabstop<"
