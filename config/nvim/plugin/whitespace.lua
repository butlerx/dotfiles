vim.api.nvim_set_hl(0, "ExtraWhitespace", { ctermbg = "red", bg = "red" })

local group = vim.api.nvim_create_augroup("Whitespace", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "neo-tree" then
      vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
    end
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "neo-tree" then
      vim.fn.clearmatches()
      vim.fn.matchadd("ExtraWhitespace", [[\s\+\%#\@<!$]])
    end
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "neo-tree" then
      vim.fn.clearmatches()
      vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
  group = group,
  pattern = "*",
  callback = function()
    vim.fn.clearmatches()
  end,
})
