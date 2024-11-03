local map = require("utils").map
local cmp = require("cmp")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    format_on_save = true,
})

-- keymaps
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

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
        "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
    })
    map({ "n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>" })
    map({ "n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>" })
    map({ "n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>" })

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.documentFormattingProvider then
        map({ "n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>" })
    elseif client.server_capabilities.documentRangeFormattingProvider then
        map({ "n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>" })
    end

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_exec(
            [[
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]],
            false
        )
    end
end

-- config that activates keymaps and enables snippet support
local function make_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
        -- enable snippet support
        capabilities = capabilities,
        -- map buffer local keybindings when the language server attaches
        on_attach = on_attach,
    }
end

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
    automatic_installation = true,
})

require("mason-lspconfig").setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({})
    end,
    ["rust_analyzer"] = function() end,
})

vim.g.rustaceanvim = {
    tools = {},
    server = {
        cmd = function()
            local mason_registry = require("mason-registry")
            local ra_binary = mason_registry.is_installed("rust-analyzer")
                    -- This may need to be tweaked, depending on the operating system.
                    and mason_registry.get_package("rust-analyzer"):get_install_path() .. "/rust-analyzer"
                or "rust-analyzer"
            return { ra_binary } -- You can add args to the list, such as '--log-file'
        end,
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
        --"autoimport",
        --"google_java_format",
        --"lua-format",
        "bash-language-server",
        "black",
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
        "luaformatter",
        "markdownlint",
        "misspell",
        "prettier",
        "proselint",
        "pyright",
        "revive",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "staticcheck",
        "stylelint",
        "stylua",
        "taplo",
        "tflint",
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
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
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
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "path" },
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
        lua = { "lua-format", "stylua" },
        python = { "autoimport", "isort", "black" },
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
        java = { "google_java_format" },
        terraform = { "terraform_fmt", "trim_newlines", "trim_whitespace" },
        toml = { "taplo" },
        ["_"] = { "trim_newlines", "trim_whitespace" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
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
