-- Only do this when not yet done for this buffer
if vim.b.did_ftplugin then
  return
end

vim.g.terraform_align = 1
vim.g.terraform_fmt_on_save = 1
-- Repo-pinned terraform (tfenv shim, vendored binary, mise pin). Must stay
-- unquoted: vim-terraform gates its entire ftplugin on
-- executable(g:terraform_binary_path), which a shell-quoted path fails, so
-- quoting silently removes :TerraformFmt. A repo path with spaces is broken here.
vim.g.terraform_binary_path = require("project").exe("terraform")
