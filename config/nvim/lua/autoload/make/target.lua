local M = {}

function M.make()
  local targets = {}

  for li = vim.fn.line("."), 1, -1 do
    local line = vim.fn.getline(li)
    local matchlist = vim.fn.matchlist(line, [[^\([^:= \t][^:=]*\):]])
    if #matchlist > 0 then
      targets = vim.fn.split(matchlist[2], [[\s\+]])
      break
    elseif line:sub(1, 1) ~= "\t" then
      break
    end
  end

  for _, target in ipairs(targets) do
    local escaped = vim.fn.exists("*shellescape") == 1 and vim.fn.shellescape(target) or target
    vim.cmd("make! -C %:p:h " .. escaped)
  end
end

return M
