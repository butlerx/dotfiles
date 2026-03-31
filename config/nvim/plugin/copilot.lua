-- setup Copilot
require("copilot").setup({
  panel = { enabled = false },
})
require("copilot_cmp").setup()

require("render-markdown").setup({
  file_types = { "markdown" },
  latex = { enabled = false },
  yaml = { enabled = false },
})

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    start = function()
      if not vim.env.TMUX then
        vim.notify("Not inside a tmux session", vim.log.levels.ERROR, { title = "opencode" })
        return
      end
      vim.fn.system('tmux split-window -h -d -p 35 "opencode --port" \\; select-pane -T opencode')
    end,
    stop = function()
      if not vim.env.TMUX then
        return
      end
      local pane_id = vim.fn.system(
        'tmux list-panes -F "#{pane_id} #{pane_title}" | grep opencode | cut -d" " -f1'
      ):gsub("%s+", "")
      if pane_id ~= "" then
        vim.fn.system("tmux kill-pane -t " .. pane_id)
      end
    end,
    toggle = function()
      if not vim.env.TMUX then
        vim.notify("Not inside a tmux session", vim.log.levels.ERROR, { title = "opencode" })
        return
      end
      local pane_id = vim.fn.system(
        'tmux list-panes -F "#{pane_id} #{pane_title}" | grep opencode | cut -d" " -f1'
      ):gsub("%s+", "")
      if pane_id ~= "" then
        vim.fn.system("tmux kill-pane -t " .. pane_id)
      else
        vim.fn.system('tmux split-window -h -d -p 35 "opencode --port" \\; select-pane -T opencode')
      end
    end,
  },
}

-- Required for opencode to reload edited buffers
vim.o.autoread = true

-- opencode keymaps
vim.keymap.set({ "n", "x" }, "<leader>oa", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask opencode" })
vim.keymap.set({ "n", "x" }, "<leader>os", function()
  require("opencode").select()
end, { desc = "Select opencode action" })
vim.keymap.set({ "n", "t" }, "<leader>oo", function()
  require("opencode").toggle()
end, { desc = "Toggle opencode" })
vim.keymap.set({ "n", "x" }, "go", function()
  return require("opencode").operator("@this ")
end, { desc = "Add range to opencode", expr = true })
vim.keymap.set("n", "goo", function()
  return require("opencode").operator("@this ") .. "_"
end, { desc = "Add line to opencode", expr = true })
