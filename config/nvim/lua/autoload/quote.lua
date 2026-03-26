local M = {}

function M.quote()
  vim.go.operatorfunc = "v:lua.require'autoload.quote'.quote_opfunc"
  return "g@"
end

function M.quote_opfunc(_type)
  local char = vim.b.quote_char or ">"

  local start_line = vim.fn.line("'[")
  local end_line = vim.fn.line("']")
  for li = start_line, end_line do
    local cur = vim.fn.getline(li)
    if not (#cur == 0 and (li == start_line or li == end_line)) then
      local first = cur:sub(1, 1)
      local new = first == char and (char .. cur) or (char .. " " .. cur)
      vim.fn.setline(li, new)
    end
  end
end

function M.quote_reformat()
  vim.go.operatorfunc = "v:lua.require'autoload.quote'.quote_reformat_opfunc"
  return "g@"
end

function M.quote_reformat_opfunc(type)
  M.quote_opfunc(type)
  vim.cmd("normal! '[gq']")
end

return M
