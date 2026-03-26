local M = {}

local digraphs

function M.search()
  local search = vim.fn.input("Digraph search: ")
  if #search == 0 then
    return
  end

  local search_upper = string.upper(search)
  local results = {}
  for _, digraph in ipairs(M.digraphs()) do
    if string.find(digraph.name, search_upper, 1, true) then
      table.insert(results, digraph)
    end
  end

  vim.cmd("redraw")
  vim.api.nvim_echo({ { "Digraphs matching " .. search_upper .. ":" } }, false, {})
  if #results > 0 then
    for _, result in ipairs(results) do
      vim.api.nvim_echo({ { result.char .. "  " .. result.keys .. "  " .. result.name } }, false, {})
    end
  else
    vim.api.nvim_echo({ { "None!" } }, false, {})
  end
end

function M.digraphs()
  if digraphs then
    return digraphs
  end

  digraphs = {}
  local table_mode = false
  local lines = vim.fn.readfile(vim.env.VIMRUNTIME .. "/doc/digraph.txt")
  for _, line in ipairs(lines) do
    table_mode = (table_mode and #line > 0) or (vim.fn.match(line, [[\C\*digraph-table\%(-mbyte\)\=\*$]]) ~= -1)
    if not table_mode then
      goto continue
    end

    local match = vim.fn.matchlist(line, [[^\(\S\)\+\s\+\(\S\S\)\s\+\%(0x\)\=\x\+\s\+\d\+\s\+\(.\+\)]])
    if #match == 0 then
      goto continue
    end

    table.insert(digraphs, {
      char = match[2],
      keys = match[3],
      name = match[4],
    })

    ::continue::
  end

  return digraphs
end

return M
