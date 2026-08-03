-- Shell dialect detection for shell ftplugins and compilers.
--
-- b:is_bash / b:is_kornshell / b:is_sh cannot be trusted at FileType time. Both
-- Neovim's filetype detection and vim-polyglot set them, and whichever loses the
-- race sets them *after* FileType has already fired -- so an ftplugin reading
-- them directly sees nil and silently falls back to plain sh. Parse the shebang
-- ourselves instead, and treat those variables only as a hint when it's absent.

local M = {}

-- Interpreter basename -> dialect. Mirrors the shells Neovim's own sh detection
-- recognises (see runtime/lua/vim/filetype/detect.lua).
local dialects = {
  bash = "bash",
  bash2 = "bash",
  ksh = "ksh",
  ksh93 = "ksh",
  mksh = "ksh",
  pdksh = "ksh",
  sh = "sh",
  dash = "sh",
}

---Dialect named by a shebang line, if it names a shell we know.
---Scans every token so `#!/usr/bin/env bash` and `#!/bin/bash -e` both work.
---@param line string
---@return string|nil
local function from_shebang(line)
  if not line:match("^#!") then
    return nil
  end

  for token in line:gmatch("%S+") do
    local base = token:match("([^/]+)$")
    if base and dialects[base] then
      return dialects[base]
    end
  end
end

---Shell dialect for a buffer: "bash", "ksh" or "sh".
---@param bufnr? integer defaults to the current buffer
---@return string
function M.dialect(bufnr)
  bufnr = bufnr or 0

  local first = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
  local shebang = first and from_shebang(first)
  if shebang then
    return shebang
  end

  -- No shebang: fall back to whatever detection managed to set, then to the
  -- g:is_* globals that Vim's sh syntax uses to pick a default dialect.
  if vim.b[bufnr].is_bash or vim.g.is_bash then
    return "bash"
  elseif vim.b[bufnr].is_kornshell or vim.g.is_kornshell then
    return "ksh"
  end

  return "sh"
end

return M
