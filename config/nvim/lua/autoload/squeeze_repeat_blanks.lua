local M = {}

function M.squeeze(start_line, end_line)
  local deletions = {}
  local group = false
  local pattern = vim.b.squeeze_repeat_blanks_blank or "^$"

  for num = start_line, end_line do
    if vim.fn.getline(num):match(pattern) == nil then
      group = false
    elseif group then
      table.insert(deletions, num - 1)
    else
      group = true
    end
  end

  for i = #deletions, 1, -1 do
    vim.cmd("silent " .. deletions[i] .. "delete")
  end

  vim.api.nvim_echo({ { tostring(#deletions) .. " deleted" } }, true, {})
end

return M
