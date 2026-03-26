local M = {}

function M.check(filename)
  if vim.fn.stridx(vim.fn.getline(1), "#!") == 0 and vim.fn.filereadable(filename) == 0 then
    local group = vim.api.nvim_create_augroup("shebang_create_exec", { clear = false })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = group,
      buffer = 0,
      callback = function(args)
        M.chmod(vim.fn.fnamemodify(args.file, ":p"))
      end,
    })
  end
end

function M.chmod(filename)
  local group = vim.api.nvim_create_augroup("shebang_create_exec", { clear = false })
  vim.api.nvim_clear_autocmds({ group = group, buffer = 0, event = "BufWritePost" })
  vim.fn.system("chmod +x " .. vim.fn.shellescape(filename))
end

return M
