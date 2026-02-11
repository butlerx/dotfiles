local map = require("utils").map
local cmp = require("cmp")

vim.diagnostic.config({
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
})

-- LSP keymaps and highlight via LspAttach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Mappings.
        map({ "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>" })
        map({ "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>" })
        map({ "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>" })
        map({ "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>" })
        map({ "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>" })
        map({ "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>" })
        map({ "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>" })
        map({
            "n",
            "<space>wl",
            "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        })
        map({ "n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>" })
        map({ "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>" })
        map({ "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>" })
        map({ "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>" })
        map({
            "n",
            "<space>e",
            "<cmd>lua vim.diagnostic.open_float()<CR>",
        })
        map({ "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>" })
        map({ "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>" })
        map({ "n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>" })

        -- Set some keybinds conditional on server capabilities
        if
            client
            and (
                client.server_capabilities.documentFormattingProvider
                or client.server_capabilities.documentRangeFormattingProvider
            )
        then
            map({ "n", "<space>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>" })
        end

        -- Set autocommands conditional on server_capabilities
        if client and client.server_capabilities.documentHighlightProvider then
            local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
                group = group,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.document_highlight()
                end,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = group,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.clear_references()
                end,
            })
        end
    end,
})

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
    pip = {
        upgrade_pip = true,
    },
})

require("mason-lspconfig").setup({
    automatic_enable = {
        exclude = { "rust_analyzer" }, -- Managed by rustaceanvim
    },
})

vim.g.rustaceanvim = {
    tools = {},
    server = {
        cmd = { "rust-analyzer" },
        default_settings = {
            ["rust-analyzer"] = {
                cargo = {
                    features = "all",
                    extraEnv = { RUSTFLAGS = "-C debuginfo=0 -A dead_code" },
                    buildScripts = {
                        enable = true,
                    },
                },
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                procMacro = {
                    enable = true,
                },
            },
        },
    },
}

require("mason-tool-installer").setup({
    ensure_installed = {
        "bash-language-server",
        "dockerfile-language-server",
        "editorconfig-checker",
        "eslint-lsp",
        "gofumpt",
        "golangci-lint",
        "golines",
        "gomodifytags",
        "gopls",
        "gotests",
        "impl",
        "json-to-struct",
        "lua-language-server",
        "luacheck",
        "markdownlint",
        "misspell",
        "prettier",
        "proselint",
        "revive",
        "ruff",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "staticcheck",
        "stylelint",
        "stylua",
        "taplo",
        "tflint",
        "ty",
        "typescript-language-server",
        "vim-language-server",
        "vint",
        "yaml-language-server",
        "yamlfmt",
    },
    auto_update = true,
    run_on_start = true,
    start_delay = 3000, -- 3 second delay
})

-- Set up nvim-cmp.
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = "copilot" },
        { name = "nvim_lsp" },
    }, {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "vsnip" },
    }, {
        { name = "buffer" },
    }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = "buffer" },
    }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        javascript = { "prettier", "eslint_d" },
        typescript = { "prettier", "eslint_d" },
        html = { "eslint_d" },
        json = { "prettier", "fixjson", "jq" },
        scss = { "prettier", "stylelint" },
        css = { "prettier", "stylelint" },
        rust = { "rustfmt", lsp_format = "fallback" },
        zsh = { "shellcheck", "shfmt" },
        bash = { "shellcheck", "shfmt" },
        sh = { "shellcheck", "shfmt" },
        go = { "gofumpt", "goimports" },
        markdown = { "prettier" },
        yaml = { "yamlfmt", "prettier" },
        ansible = { "prettier" },
        terraform = { "terraform_fmt", "trim_newlines", "trim_whitespace" },
        toml = { "taplo" },
        ["*"] = { "trim_newlines", "trim_whitespace" },
    },
    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
    end,
})

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})
