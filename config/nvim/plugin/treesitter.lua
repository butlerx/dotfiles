require("nvim-treesitter.configs").setup {
    refactor = {
        highlight = { enable = true },
        highlight_definitions = { enable = true },
        indent = { enable = true },
        smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
    },
}
