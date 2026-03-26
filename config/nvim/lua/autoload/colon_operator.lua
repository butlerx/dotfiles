local M = {}

local command

function M.operatorfunc(_type)
  if not command then
    command = vim.fn.input("g:", "", "command")
  end
  vim.cmd("'[,']" .. command)
end

function M.map()
  command = nil
  vim.go.operatorfunc = "v:lua.require'autoload.colon_operator'.operatorfunc"
  return "g@"
end

return M
