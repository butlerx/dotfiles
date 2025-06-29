require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    refactor = {
        highlight = { enable = true },
        highlight_definitions = { enable = true },
        indent = { enable = true },
        smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
    },
})
