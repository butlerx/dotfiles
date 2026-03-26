local M = {}

function M.flag_important()
  vim.fn.cursor(1, 1)
  vim.fn.search("^$")
  vim.cmd("-")
  vim.fn.append(vim.fn.line("."), "X-Priority: 1")
  vim.fn.append(vim.fn.line("."), "Importance: High")
end

function M.flag_unimportant()
  vim.fn.cursor(1, 1)
  vim.fn.search("^$")
  vim.cmd("-")
  vim.fn.append(vim.fn.line("."), "X-Priority: 5")
  vim.fn.append(vim.fn.line("."), "Importance: Low")
end

function M.new_blank(count, up, visual)
  if visual ~= 0 then
    vim.cmd("normal! gv")
  end

  local block = false
  local blocks = 0
  local num = vim.fn.line(".")

  while (up ~= 0 and num > 1) or (up == 0 and num < vim.fn.line("$")) do
    if vim.fn.match(vim.fn.getline(num), "^[ >]*$") ~= -1 then
      if block then
        block = false
        blocks = blocks + 1
      end
      if blocks == count then
        break
      end
    else
      block = true
    end
    num = num + (up ~= 0 and -1 or 1)
  end

  if num ~= vim.fn.line(".") then
    vim.cmd("normal " .. num .. "G")
  end
end

function M.contract_multiple_blank_lines()
  local deletions = {}
  local blank = false
  for num = 1, vim.fn.line("$") do
    if vim.fn.match(vim.fn.getline(num), "^[> ]*$") == -1 then
      blank = false
    elseif blank then
      table.insert(deletions, num - 1)
    else
      blank = true
    end
  end
  for i = #deletions, 1, -1 do
    vim.cmd(deletions[i] .. "delete")
  end
end

return M
