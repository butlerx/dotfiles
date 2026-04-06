local tmux_ok, claude_tmux = pcall(require, "claude-tmux")
if not tmux_ok then
  vim.notify("claudecode: failed to load claude-tmux: " .. tostring(claude_tmux), vim.log.levels.WARN)
  return
end

local claude_ok, claudecode = pcall(require, "claudecode")
if not claude_ok then
  vim.notify("claudecode: failed to load claudecode: " .. tostring(claudecode), vim.log.levels.WARN)
  return
end

local tmux_provider = claude_tmux.setup({
  split_size = 35,
})

claudecode.setup({
  terminal = {
    provider = tmux_provider,
  },
})

vim.o.autoread = true

vim.keymap.set({ "n", "t" }, "<leader>aa", "<cmd>ClaudeCode<cr>", { desc = "Claude Toggle" })
vim.keymap.set({ "n", "t" }, "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Claude Focus" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Claude Send Selection" })
vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd<cr>", { desc = "Claude Add Buffer" })
vim.keymap.set("n", "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Claude Diff Accept" })
vim.keymap.set("n", "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Claude Diff Deny" })
