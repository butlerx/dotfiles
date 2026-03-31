local gh = function(repo)
  return "https://github.com/" .. repo
end

-- Build hooks: must be registered BEFORE vim.pack.add() to catch initial installs
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    if kind == "install" or kind == "update" then
      if name == "nvim-treesitter" then
        if not ev.data.active then
          vim.cmd.packadd("nvim-treesitter")
        end
        vim.cmd("TSUpdate")
      end

      if name == "vim-go" then
        if not ev.data.active then
          vim.cmd.packadd("vim-go")
        end
        vim.cmd("GoInstallBinaries")
      end
    end
  end,
})

-- Core plugins (loaded at startup)
vim.pack.add({
  -- Dependencies (order matters - list deps before dependents)
  gh("nvim-lua/plenary.nvim"),
  gh("MunifTanjim/nui.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("ryanoasis/vim-devicons"),

  -- Treesitter
  gh("nvim-treesitter/nvim-treesitter"),

  -- LSP & completion
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  gh("mason-org/mason-lspconfig.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  gh("hrsh7th/nvim-cmp"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/cmp-cmdline"),
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("hrsh7th/cmp-path"),
  gh("hrsh7th/cmp-vsnip"),
  gh("hrsh7th/vim-vsnip"),
  gh("stevearc/conform.nvim"),

  -- Copilot & AI
  gh("zbirenbaum/copilot.lua"),
  gh("zbirenbaum/copilot-cmp"),
  gh("MeanderingProgrammer/render-markdown.nvim"),
  gh("nickjvandyke/opencode.nvim"),

  -- Git
  gh("tpope/vim-fugitive"),
  gh("gregsexton/gitv"),
  gh("lewis6991/gitsigns.nvim"),

  -- Navigation & search
  gh("nvim-telescope/telescope.nvim"),
  gh("ibhagwan/fzf-lua"),
  { src = gh("nvim-neo-tree/neo-tree.nvim"), version = "v3.x" },
  gh("christoomey/vim-tmux-navigator"),

  -- Editing
  gh("tpope/vim-surround"),
  gh("scrooloose/nerdcommenter"),
  gh("godlygeek/tabular"),

  -- UI
  gh("sickill/vim-monokai"),
  gh("vim-airline/vim-airline"),
  gh("vim-airline/vim-airline-themes"),
  gh("Yggdroot/indentLine"),
  gh("folke/snacks.nvim"),
  gh("mhinz/vim-startify"),

  -- Language support (always loaded)
  gh("sheerun/vim-polyglot"),
})

-- Filetype lazy-loaded plugins
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "toml" },
  once = true,
  callback = function()
    vim.pack.add({ gh("cespare/vim-toml") })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv" },
  once = true,
  callback = function()
    vim.pack.add({ gh("chrisbra/csv.vim") })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "Dockerfile", "docker-compose" },
  once = true,
  callback = function()
    vim.pack.add({ gh("ekalinin/Dockerfile.vim") })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gohtmltmpl" },
  once = true,
  callback = function()
    vim.pack.add({
      { src = gh("fatih/vim-go") },
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  once = true,
  callback = function()
    vim.pack.add({ gh("elzr/vim-json") })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "jsonnet" },
  once = true,
  callback = function()
    vim.pack.add({ gh("google/vim-jsonnet") })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "terraform", "hcl" },
  once = true,
  callback = function()
    vim.pack.add({ gh("hashivim/vim-terraform") })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript.tsx", "typescriptreact", "typescript", "javascript", "vue" },
  once = true,
  callback = function()
    vim.pack.add({
      gh("leafgarland/typescript-vim"),
      gh("pangloss/vim-javascript"),
      gh("moll/vim-node"),
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust" },
  once = true,
  callback = function()
    vim.pack.add({
      gh("rust-lang/rust.vim"),
      gh("mrcjkb/rustaceanvim"),
    })
  end,
})
