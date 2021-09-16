-- Only do this when not yet done for this buffer
if vim.b.did_ftplugin then
    return
end

vim.g.terraform_align = 1
vim.g.terraform_fmt_on_save = 1
