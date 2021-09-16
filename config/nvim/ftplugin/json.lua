-- Only do this when not yet done for this buffer
if vim.b.did_ftplugin then
    return
end

-- vim-json
vim.g.vim_json_syntax_conceal = 0
