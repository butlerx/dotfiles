local M = {}

function M.move_block(count, up, visual)
  if visual ~= 0 then
    vim.cmd("normal! gv")
  end

  local blocks = 0
  local num = vim.fn.line(".")
  while (up ~= 0 and num > 1) or (up == 0 and num < vim.fn.line("$")) do
    num = num + (up ~= 0 and -1 or 1)
    if vim.fn.getline(num):match("^@@") then
      blocks = blocks + 1
      if blocks == count then
        break
      end
    end
  end

  if num ~= vim.fn.line(".") then
    vim.cmd("normal " .. num .. "G")
  end
end

return M
