local map = require("utils").map
local lsp_installer = require("nvim-lsp-installer")
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
	if client.resolved_capabilities.document_formatting then
		map({ "n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>" })
	elseif client.resolved_capabilities.document_range_formatting then
		map({ "n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>" })
	end

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
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

-- Include the servers you want to have installed by default below
local servers = {
	"sumneko_lua",
	"ansiblels",
	"bashls",
	"dockerls",
	"eslint",
	"gopls",
	"groovyls",
	"puppet",
	"pyright",
	"rust_analyzer",
	"tflint",
	"tsserver",
	"yamlls",
	"zk",
}

for _, name in pairs(servers) do
	local server_is_found, server = lsp_installer.get_server(name)
	if server_is_found then
		if not server:is_installed() then
			server:install()
		end
	end
end

local enhance_server_opts = {
	["eslintls"] = function(opts)
		opts.settings = {
			format = {
				enable = true,
			},
		}
	end,
}

lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = on_attach,
	}

	if enhance_server_opts[server.name] then
		-- Enhance the default opts with the server-specific ones
		enhance_server_opts[server.name](opts)
	end
	if server.name == "rust_analyzer" then
		-- Initialize the LSP via rust-tools instead
		require("rust-tools").setup({
			server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
		})
		server:attach_buffers()
	else
		server:setup(opts)
	end
end)

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = { ["<C-y>"] = cmp.mapping.confirm({ select = true }) },
})
