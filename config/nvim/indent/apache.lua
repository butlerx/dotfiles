-- Language:     apache
-- Maintainer:   Satya P <vim@thesatya.com>
-- Last Change:  Sat, 27 Jan 2007 11:24:59 EST
-- Notes:        0) Copied from Johannes Zellner <johannes@zellner.org>'s xml
--                  indent script

-- Only load this indent file when no other was loaded.
if vim.b.did_indent then
  return
end
vim.b.did_indent = true

-- [-- local settings (must come before aborting the script) --]
vim.bo.indentexpr = "v:lua.require'indent.apache'.get()"
vim.bo.indentkeys = "o,O,*<Return>,<>>,<<>,/,{,}"

--- Get indent level for the current line in an Apache config file.
--- Increases indent after opening tags, decreases for closing tags.
--- @return number
local function get()
  local lnum = vim.v.lnum

  -- Find a non-empty line above the current line.
  local prevlnum = vim.fn.prevnonblank(lnum - 1)

  -- Hit the start of the file, use zero indent.
  if prevlnum == 0 then
    return 0
  end

  local prevline = vim.fn.getline(prevlnum)
  local line = vim.fn.getline(lnum)
  local ind = vim.fn.indent(prevlnum)
  local sw = vim.fn.shiftwidth()
  local delta = 0

  -- if this is a closing tag line, reduce its indentation
  if line:match("^%s*</") then
    delta = -sw
  -- if previous line is an opening tag line, increase its indentation
  elseif prevline:match("^%s*<%a") then
    delta = sw
  end

  return ind + delta
end

return { get = get }
