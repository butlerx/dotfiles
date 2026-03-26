local M = {}

function M.plug_load()
  local plug_file = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
  if vim.fn.empty(vim.fn.glob(plug_file)) == 1 then
    if vim.fn.executable("curl") == 1 then
      vim.cmd('echom "Installing vim-plug at ' .. plug_file .. '"')
      local plug_url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
      vim.fn.system({ "curl", "-fLo", plug_file, "--create-dirs", plug_url })
      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        command = "PlugInstall --sync | source $MYVIMRC",
        once = true,
      })
    else
      vim.cmd('echom "vim-plug not installed. Please install it manually or install curl."')
      return
    end
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    local missing = {}
    for _, plug in pairs(vim.g.plugs or {}) do
      if type(plug) == "table" and plug.dir and vim.fn.isdirectory(plug.dir) == 0 then
        table.insert(missing, plug)
      end
    end
    if #missing > 0 then
      vim.cmd("PlugInstall --sync | q")
    end
  end,
})

return M
