if vim.env.VIM ~= "/usr/share/vim" or not vim.fn.filereadable("/etc/debian_version") then
  return
end

vim.opt.history = vim.api.nvim_get_option_info2("history", {}).default
vim.opt.suffixes = vim.api.nvim_get_option_info2("suffixes", {}).default
vim.opt.ruler = vim.api.nvim_get_option_info2("ruler", {}).default
vim.opt.printoptions = vim.api.nvim_get_option_info2("printoptions", {}).default

vim.cmd([[set t_Co& t_Sf& t_Sb&]])
vim.cmd([[set t_Co=256]])

vim.opt.runtimepath:remove("/var/lib/vim/addons")
vim.opt.runtimepath:remove("/var/lib/vim/addons/after")
