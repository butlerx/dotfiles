local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
    return
end

ts.setup({})

ts.install({
    "bash",
    "css",
    "dockerfile",
    "go",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "python",
    "query",
    "rust",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
            return
        end
        local has_parser = pcall(vim.treesitter.language.add, lang)
        if not has_parser then
            return
        end
        local ok_start = pcall(vim.treesitter.start, args.buf, lang)
        if ok_start then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
