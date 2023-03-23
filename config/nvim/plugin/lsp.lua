local map = require("utils").map
local cmp = require("cmp")
require("nvim-ale-diagnostic")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = false,
	virtual_text = false,
	signs = true,
	update_in_insert = false,
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
	["rust_analyzer"] = function()
		require("rust-tools").setup({})
	end,
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"bash-language-server",
		"black",
		"dockerfile-language-server",
		"eslint-lsp",
		"eslint_d",
		"gofumpt",
		"golangci-lint",
		"gopls",
		"lua-language-server",
		"luacheck",
		"luaformatter",
		"shellharden",
		"markdownlint",
		"misspell",
		"prettier",
		"proselint",
		"pyright",
		"revive",
		"rust-analyzer",
		"rustfmt",
		"shellcheck",
		"shfmt",
		"staticcheck",
		"stylua",
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

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = { ["<C-y>"] = cmp.mapping.confirm({ select = true }) },
})
