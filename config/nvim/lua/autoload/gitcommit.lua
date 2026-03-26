local M = {}

function M.cursor_column()
  for num = 1, vim.fn.line("$") do
    if num ~= 1 then
      local line = vim.fn.getline(num)
      if line:sub(1, 1) ~= "#" then
        return "+1"
      elseif vim.fn.match(line, [[^# -\{24} >8 -\{24}$]]) ~= -1 then
        break
      end
    end
  end

  return "51"
end

return M
