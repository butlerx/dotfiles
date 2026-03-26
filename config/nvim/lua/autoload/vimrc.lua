local M = {}

function M.anchor(keys)
  local view = vim.fn.winsaveview()
  vim.cmd("normal! " .. keys)
  vim.fn.winrestview(view)
end

return M
