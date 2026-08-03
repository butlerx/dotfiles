local map = require("utils").map
local cmp = require("cmp")
local project = require("project")

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
    map({ "n", "[d", "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>" })
    map({ "n", "]d", "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>" })
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

-- Prefer a language server the repo installs itself (node_modules/.bin,
-- .venv/bin, a mise pin) over the mason copy, so the server matches the
-- dependencies it is analysing.
--
-- `cmd` must be a function rather than a list: the binary can only be resolved
-- once root_dir is known, which is at spawn time. One nvim session therefore
-- talks to a different binary per project.
local function prefer_local_server(name)
  local ok, conf = pcall(function()
    return vim.lsp.config[name]
  end)
  if not ok or type(conf) ~= "table" or type(conf.cmd) ~= "table" then
    return
  end

  local argv = conf.cmd
  vim.lsp.config(name, {
    cmd = function(dispatchers, config)
      local root = config.root_dir
      local cwd = config.cmd_cwd or ((root and vim.fn.isdirectory(root) == 1) and root or nil)
      return vim.lsp.rpc.start(project.localize_argv(argv, root), dispatchers, {
        cwd = cwd,
        env = config.cmd_env,
      })
    end,
  })
end

for _, name in ipairs(require("mason-lspconfig").get_installed_servers()) do
  if name ~= "rust_analyzer" then
    prefer_local_server(name)
  end
end

-- Neovim-flavoured lua_ls defaults, for editing configs like this one. A repo
-- shipping .luarc.json owns its settings outright, so bail before touching them.
vim.lsp.config("lua_ls", {
  on_init = function(client)
    local folder = client.workspace_folders and client.workspace_folders[1]
    if
      folder
      and folder.name ~= vim.fn.stdpath("config")
      and (vim.uv.fs_stat(folder.name .. "/.luarc.json") or vim.uv.fs_stat(folder.name .. "/.luarc.jsonc"))
    then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
      completion = { enable = true, showWord = "Disable" },
      runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
      telemetry = { enable = false },
    })
  end,
})

vim.g.rustaceanvim = {
  tools = {},
  server = {
    -- A function so it resolves per rust buffer, not once at startup.
    cmd = function()
      return project.localize_argv({ "rust-analyzer" })
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
    "markdownlint",
    "misspell",
    "prettier",
    "proselint",
    "revive",
    "ruff",
    "rust-analyzer",
    "selene",
    "shellcheck",
    "shfmt",
    "staticcheck",
    "stylelint",
    "stylua",
    "tombi",
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
    { name = "cmp_tabby" },
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

-- Advertise nvim-cmp's extra completion capabilities to every server.
vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

local conform_util = require("conform.util")

-- `command` resolvers: repo-local binary first, mise pin second, global last.
local exe = project.formatter_cmd

-- Config-file detectors. Paired with `require_cwd = true` they make a formatter
-- opt-in: with no config in the repo, conform skips it rather than running
-- whatever global copy happens to be installed.
local root_of = conform_util.root_file

local eslint_config = root_of({
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
})

local stylelint_config = root_of({
  ".stylelintrc",
  ".stylelintrc.js",
  ".stylelintrc.cjs",
  ".stylelintrc.mjs",
  ".stylelintrc.json",
  ".stylelintrc.yaml",
  ".stylelintrc.yml",
  "stylelint.config.js",
  "stylelint.config.cjs",
  "stylelint.config.mjs",
})

require("conform").setup({
  formatters = {
    -- Node tools: conform already checks node_modules/.bin, but not mise pins.
    prettier = { command = exe("prettier") },
    fixjson = { command = exe("fixjson"), cwd = root_of({ "package.json" }) },

    -- Only run if the repo actually configures them.
    eslint_d = {
      command = exe("eslint_d", { paths = { "node_modules/.bin/eslint" } }),
      cwd = eslint_config,
      require_cwd = true,
    },
    stylelint = {
      command = exe("stylelint"),
      cwd = stylelint_config,
      require_cwd = true,
    },

    -- Python: a repo's virtualenv ruff is pinned to its own rule set.
    ruff_format = { command = exe("ruff") },
    ruff_organize_imports = { command = exe("ruff") },

    stylua = { command = exe("stylua") },
    rustfmt = { command = exe("rustfmt") },
    shfmt = { command = exe("shfmt") },
    shellcheck = { command = exe("shellcheck") },
    jq = { command = exe("jq") },

    -- Go tools need the module root as cwd to resolve imports correctly.
    gofumpt = { command = exe("gofumpt"), cwd = root_of({ "go.work", "go.mod" }) },
    goimports = { command = exe("goimports"), cwd = root_of({ "go.work", "go.mod" }) },

    -- yamlfmt only finds its config relative to cwd.
    yamlfmt = {
      command = exe("yamlfmt"),
      cwd = root_of({ ".yamlfmt", ".yamlfmt.yaml", ".yamlfmt.yml", "yamlfmt.yaml", "yamlfmt.yml" }),
    },
    tombi = { command = exe("tombi"), cwd = root_of({ "tombi.toml", "pyproject.toml" }) },
    terraform_fmt = {
      command = exe("terraform"),
      cwd = root_of({ ".terraform.lock.hcl", ".terraform-version", ".terraform" }),
    },
  },
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
    toml = { "tombi" },
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
