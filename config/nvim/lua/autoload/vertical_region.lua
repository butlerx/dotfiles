local M = {}

function M.map(count, up, mode)
  if mode == "x" then
    vim.cmd("normal! gv")
  end

  local num = vim.fn.line(".")
  local col = vim.fn.col(".")

  local hits = 0
  while (up ~= 0 and num > 1) or (up == 0 and num < vim.fn.line("$")) do
    num = num + (up ~= 0 and -1 or 1)
    local line = vim.fn.getline(num)
    if line:sub(1, col):find("%S") then
      hits = hits + 1
      if hits == count then
        break
      end
    end
  end

  local keys = tostring(num) .. "G0"
  if mode == "o" then
    keys = "V" .. keys
  elseif col > 1 then
    keys = keys .. tostring(col - 1) .. "l"
  end

  vim.cmd("normal! " .. keys)
end

return M
