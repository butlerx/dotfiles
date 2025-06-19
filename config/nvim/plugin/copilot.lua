-- setup Copilot
require("copilot").setup({
    panel = { enabled = false },
})
require("copilot_cmp").setup()
require("img-clip").setup({
    default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
            insert_mode = true,
        },
        -- required for Windows users
        use_absolute_path = true,
    },
})
require("render-markdown").setup({
    file_types = { "markdown", "Avante" },
})
require("avante").setup({
    provider = "copilot",
    providers = {
        copilot = {
            model = "claude-sonnet-4",
        },
    },
    behaviour = {
        auto_suggestions = false,
        auto_apply_diff_after_generation = true,
    },
})
