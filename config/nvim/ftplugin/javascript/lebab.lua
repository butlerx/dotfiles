-- Invoke the `lebab` tool on the current buffer (https://github.com/lebab/lebab)
--
-- Usage:
--
--   :Lebab <transform1> <transform2> [...]
--
-- This will run all the transforms specified and replace the buffer with the
-- results. The available transforms tab-complete.
--

local lebab_transforms = {}

local function lebab_complete(_argument_lead, _command_line, _cursor_position)
  if #lebab_transforms == 0 then
    local lines = vim.fn.systemlist("lebab --help | egrep '^\\s+\\+'")
    for _, line in ipairs(lines) do
      local transform = vim.fn.matchstr(line, [[^\s\++ \zs[a-zA-Z-]\+]])
      if transform ~= '' then
        table.insert(lebab_transforms, transform)
      end
    end
    table.sort(lebab_transforms)
  end
  return table.concat(lebab_transforms, '\n')
end

local function lebab(opts)
  local transforms = opts.fargs
  local filename = vim.fn.expand('%:p')
  local command_line = 'lebab ' .. vim.fn.shellescape(filename) .. ' --transform ' .. table.concat(transforms, ',')
  local new_lines = vim.fn.systemlist(command_line)
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln('There was an error running lebab: ' .. table.concat(new_lines, '\n'))
    return
  end
  vim.cmd('%delete _')
  vim.fn.setline(1, new_lines)
end

vim.api.nvim_buf_create_user_command(0, 'Lebab', lebab, {
  nargs = '+',
  complete = lebab_complete,
})
