if vim.g.loaded_shebang_create_exec then
  return
end
vim.g.loaded_shebang_create_exec = 1

local group = vim.api.nvim_create_augroup("shebang_create_exec", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*",
  callback = function(args)
    require("autoload.shebang_create_exec").check(vim.fn.fnamemodify(args.file, ":p"))
  end,
})
