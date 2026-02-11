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

-- setup opencode.nvim
---@type opencode.Opts
vim.g.opencode_opts = {
    provider = {
        enabled = "tmux",
    },
}

-- Required for opencode to reload edited buffers
vim.o.autoread = true

-- opencode keymaps
vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end, { desc = "Select opencode action" })
vim.keymap.set({ "n", "t" }, "<leader>oo", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end, { desc = "Add range to opencode", expr = true })
vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })
