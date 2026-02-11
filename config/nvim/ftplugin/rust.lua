local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    L = {
        name = "Rust",
        h = {
            function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end,
            "Toggle Hints",
        },
        r = { "<cmd>RustLsp runnables<Cr>", "Runnables" },
        t = { "<cmd>RustLsp testables<Cr>", "Testables" },
        m = { "<cmd>RustLsp expandMacro<Cr>", "Expand Macro" },
        c = { "<cmd>RustLsp openCargo<Cr>", "Open Cargo" },
        p = { "<cmd>RustLsp parentModule<Cr>", "Parent Module" },
        d = { "<cmd>RustLsp debuggables<Cr>", "Debuggables" },
        v = { "<cmd>RustLsp crateGraph<Cr>", "View Crate Graph" },
        b = { "<cmd>RustLsp run<Cr>", "Run" },
        R = { "<cmd>RustLsp reloadWorkspace<Cr>", "Reload Workspace" },
        o = { "<cmd>RustLsp openDocs<Cr>", "Open External Docs" },
        e = { "<cmd>RustLsp explainError<Cr>", "Explain Error" },
        D = { "<cmd>RustLsp renderDiagnostic<Cr>", "Render Diagnostic" },
    },
}

which_key.register(mappings, opts)

local notify_filter = vim.notify
vim.notify = function(msg, ...)
    if msg:match("message with no corresponding") then
        return
    end

    notify_filter(msg, ...)
end

vim.keymap.set("n", "<m-d>", "<cmd>RustLsp openDocs<Cr>", { noremap = true, silent = true })
