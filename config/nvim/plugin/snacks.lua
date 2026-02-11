-- Snacks.nvim configuration
local ok, snacks = pcall(require, "snacks")
if not ok then
    return
end

snacks.setup({
    -- Enable bigfile for large file handling
    bigfile = { enabled = true },
    
    -- Enable quickfile for fast file operations
    quickfile = { enabled = true },
    
    -- Enable words for word highlighting
    words = { enabled = true },
    
    -- Configure terminal
    terminal = {
        enabled = true,
    },
    
    -- Configure toggle
    toggle = {
        enabled = true,
    },
    
    -- Configure scope for better indentation
    scope = {
        enabled = true,
    },
    
    -- Configure scroll for smooth scrolling
    scroll = {
        enabled = true,
    },
    
    -- Configure statuscolumn
    statuscolumn = {
        enabled = true,
    },
    
    -- Disable features that require additional dependencies for now
    dashboard = { enabled = false },
    explorer = { enabled = false },
    image = { enabled = false },
    input = { enabled = true },
    lazygit = { enabled = false },
    notifier = { enabled = false },
    picker = { enabled = true },
})

