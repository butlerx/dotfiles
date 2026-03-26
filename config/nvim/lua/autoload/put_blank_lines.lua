local M = {}

function M.above()
  vim.go.operatorfunc = "v:lua.require'autoload.put_blank_lines'.above_opfunc"
  return "g@^"
end

function M.above_opfunc(_type)
  vim.cmd("silent put! =repeat(nr2char(10), v:count1)")
  vim.cmd("']+1")
end

function M.below()
  vim.go.operatorfunc = "v:lua.require'autoload.put_blank_lines'.below_opfunc"
  return "g@^"
end

function M.below_opfunc(_type)
  vim.cmd("silent put =repeat(nr2char(10), v:count1)")
  vim.cmd("'[-1")
end

return M
