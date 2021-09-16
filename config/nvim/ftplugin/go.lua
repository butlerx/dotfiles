-- Only do this when not yet done for this buffer
if vim.b.did_ftplugin then
    return
end

vim.g.go_fmt_autosave = 0
vim.g.go_imports_autosave = 0
vim.g.go_metalinter_autosave = 0
vim.g.go_fmt_command = "gopls"
vim.g.go_metalinter_command = "golangci-lint"
vim.g.go_gopls_gofumpt = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_types = 1
