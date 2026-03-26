local M = {}

function M.prune(type)
  local range
  local block_type = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
  if type == "v" or type == "V" or type == block_type then
    range = "'<,'>"
  else
    range = "'[,']"
  end

  local search_save = vim.fn.getreg("/")
  vim.cmd("silent " .. range .. "substitute/^-/ /e")
  vim.cmd("silent " .. range .. "global/^+/d")
  vim.fn.setreg("/", search_save)

  local file_changes = 0
  local block_changes = 0
  local deletions = {}

  local line_count = vim.fn.line("$")
  local file_start = nil
  local block_start = nil
  for li = 1, line_count + 1 do
    local eof = li > line_count
    local line = ""
    if not eof then
      line = vim.fn.getline(li)
      deletions[li] = false
    end

    local file = (not eof) and vim.fn.stridx(line, "diff") == 0
    local block = (not eof) and vim.fn.stridx(line, "@@") == 0
    local change = (not eof) and (vim.fn.stridx(line, "+") == 0 or vim.fn.stridx(line, "-") == 0) and block_start ~= nil

    if file or eof then
      if file_start ~= nil and file_changes == 0 then
        for di = file_start, li - 1 do
          deletions[di] = true
        end
      end
      file_start = nil
      file_changes = 0
    end

    if file then
      file_start = li
      file_changes = 0
    end

    if block or file or eof then
      if block_start ~= nil and block_changes == 0 then
        for di = block_start, li - 1 do
          deletions[di] = true
        end
      end
      block_start = nil
      block_changes = 0
    end

    if block then
      block_start = li
      block_changes = 0
    end

    if change then
      file_changes = file_changes + 1
      block_changes = block_changes + 1
    end
  end

  for di = line_count, 1, -1 do
    if deletions[di] then
      vim.cmd("silent " .. di .. "delete")
    end
  end
end

return M
