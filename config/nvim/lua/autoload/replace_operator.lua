local M = {}

function M.operatorfunc(type)
  local register = vim.g.replace_operator_register
  local text = nil
  if register == '"' then
    text = vim.fn.getreg(register)
  end

  if type == "v" or type == "V" then
    vim.cmd("normal! gv")
  elseif type == vim.api.nvim_replace_termcodes("<C-V>", true, true, true) then
    vim.api.nvim_err_writeln("Visual block mode replace not supported")
    return
  elseif type == "line" then
    vim.cmd("normal! '[V']")
  else
    vim.cmd("normal! `[v`]")
  end

  vim.cmd("normal! d")
  if register == '"' then
    vim.fn.setreg(register, text)
  end

  local linewise = type == "V" or type == "line"
  local paste
  if (linewise and vim.fn.line(".") < vim.fn.line("'[")) or ((not linewise) and vim.fn.col(".") < vim.fn.col("'[")) then
    paste = "p"
  else
    paste = "P"
  end

  vim.cmd('normal "' .. register .. paste)
end

function M.map_normal(register)
  vim.g.replace_operator_register = register
  vim.go.operatorfunc = "v:lua.require'autoload.replace_operator'.operatorfunc"
end

function M.map_visual(register, visualmode)
  vim.g.replace_operator_register = register
  M.operatorfunc(visualmode)
end

return M
