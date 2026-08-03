-- Helpers for `compiler/*.lua` files.
--
-- `prg()` is the reason these exist: a checker should be the one the repo ships
-- (vendor/bin/perlcritic, node_modules/.bin/..., a mise pin) rather than whatever
-- happens to be first on $PATH.

local M = {}

---True if this compiler file should bail because another already ran.
---@param name string
---@return boolean
function M.claim(name)
  if vim.g.current_compiler then
    return false
  end
  vim.g.current_compiler = name

  -- `:compiler` defines this; provide a fallback for direct sourcing.
  if vim.fn.exists(":CompilerSet") ~= 2 then
    vim.cmd("command! -nargs=* CompilerSet setlocal <args>")
  end
  return true
end

---Set an option the `:CompilerSet` way, so `:compiler!` still sets it globally.
---@param option string
---@param value string
function M.set(option, value)
  vim.cmd("CompilerSet " .. option .. "=" .. vim.fn.escape(value, ' \\|"'))
end

---Project-local path for a checker, falling back to the bare name. Shell-quoted,
---since `makeprg` is handed to the shell and splits on unescaped spaces.
---@param cmd string
---@param opts? table see `project.find_bin`
---@return string
function M.prg(cmd, opts)
  return require("project").shell_exe(cmd, opts)
end

return M
