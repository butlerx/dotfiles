local M = {}

function M.boilerplate()
  local blank = vim.fn.line2byte(vim.fn.line("$") + 1) <= 2

  local package
  if vim.fn.expand("%:e") == "pm" then
    local match = vim.fn.matchlist(vim.fn.expand("%:p"), [[.*/lib/\(.\+\)\.pm$]])
    if #match > 0 then
      package = vim.fn.substitute(match[2], "/", "::", "g")
    else
      package = vim.fn.expand("%:t:r")
    end
  else
    package = "main"
  end

  local lines = {
    "package " .. package .. ";",
    "",
    "use strict;",
    "use warnings;",
    "use utf8;",
    "",
    "use 5.006;",
    "",
    "our $VERSION = '0.01';",
    "",
  }

  if package == "main" then
    table.insert(lines, 1, "#!perl")
  else
    table.insert(lines, "")
    table.insert(lines, "1;")
  end

  local at = vim.fn.line(".") - 1
  for _, line in ipairs(lines) do
    vim.fn.append(at, line)
    at = at + 1
  end

  if blank then
    vim.cmd("delete")
  end

  if package ~= "main" then
    vim.cmd("-2")
  end
end

return M
