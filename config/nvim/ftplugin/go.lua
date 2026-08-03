-- Only do this when not yet done for this buffer
if vim.b.did_ftplugin then
  return
end

vim.g.go_fmt_autosave = 0
vim.g.go_imports_autosave = 0
vim.g.go_metalinter_autosave = 0
-- Sentinels, not paths: vim-go compares these against the literal strings
-- "gopls" and "golangci-lint" to select a code path, so substituting a resolved
-- path silently changes behaviour. Steer tool lookup with go_bin_path instead.
vim.g.go_fmt_command = "gopls"
vim.g.go_metalinter_command = "golangci-lint"

-- Repo-vendored Go tooling. vim-go prepends this to $PATH, so tools absent from
-- it still resolve globally.
local go_bin = require("project").find_dir({ "bin", "tools/bin", ".bin" })
if go_bin then
  vim.g.go_bin_path = go_bin
  vim.g.go_search_bin_path_first = 1
end
vim.g.go_gopls_gofumpt = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_types = 1
