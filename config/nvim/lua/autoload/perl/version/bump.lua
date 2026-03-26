local M = {}

local pattern = vim.g["perl#version#bump#pattern"]
  or ([[\m\C^]] .. [[\(our\s\+\$VERSION\s*=\D*\)]] .. [[\(\d\+\)\.\(\d\+\)]] .. [[\(.*\)]])

local function format_num(old, new)
  local new_s = tostring(new)
  local pad = #old - #new_s
  if pad < 0 then
    pad = 0
  end
  return string.rep("0", pad) .. new_s
end

local function bump(major)
  local view = vim.fn.winsaveview()
  local li = vim.fn.search(pattern)
  if li == 0 then
    vim.api.nvim_echo({ { "No version number declaration found" } }, true, {})
    return
  end

  local matches = vim.fn.matchlist(vim.fn.getline(li), pattern)
  local lvalue = matches[2]
  local major_s = matches[3]
  local minor_s = matches[4]
  local rest = matches[5]

  if major then
    major_s = format_num(major_s, tonumber(major_s) + 1)
    minor_s = format_num(minor_s, 0)
  else
    minor_s = format_num(minor_s, tonumber(minor_s) + 1)
  end

  local version = major_s .. "." .. minor_s
  vim.fn.setline(li, lvalue .. version .. rest)
  if major then
    vim.api.nvim_echo({ { "Bumped major $VERSION: " .. version } }, true, {})
  else
    vim.api.nvim_echo({ { "Bumped minor $VERSION: " .. version } }, true, {})
  end
  vim.fn.winrestview(view)
end

function M.major()
  bump(true)
end

function M.minor()
  bump(false)
end

return M
