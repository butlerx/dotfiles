local M = {}

function M.url_link()
  vim.cmd("normal! yiW")
  vim.cmd('normal! i<a href="">')
  vim.cmd("normal! hP")
  vim.cmd("normal! E")
  vim.cmd("normal! a</a>")
end

function M.timestamp_update()
  if not vim.bo.modified then
    return
  end

  local cv = vim.fn.winsaveview()
  vim.fn.cursor(1, 1)
  local li = vim.fn.search([[\C^\s*<em>Last updated: .\+</em>$]], "n")
  if li ~= 0 then
    local date = vim.fn.substitute(vim.fn.system("date -u"), [[\C\n$]], "", "")
    local line = vim.fn.getline(li)
    vim.fn.setline(li, vim.fn.substitute(line, [[\C\S.*]], "<em>Last updated: " .. date .. "</em>", ""))
  end
  vim.fn.winrestview(cv)
end

return M
