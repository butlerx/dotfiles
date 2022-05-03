local utils = require "utils"

vim.g["ale_fixers"] = {
    ["javascript"] = { "prettier", "eslint" },
    ["typescript"] = { "prettier", "tslint", "eslint" },
    ["typescriptreact"] = { "prettier", "tslint", "eslint" },
    ["html"] = { "eslint" },
    ["json"] = { "prettier", "fixjson", "jq" },
    ["scss"] = { "prettier", "stylelint" },
    ["css"] = { "prettier", "stylelint" },
    ["less"] = { "prettier", "stylelint" },
    ["stylus"] = { "stylelint" },
    ["c"] = { "clang-format" },
    ["cpp"] = { "clang-format" },
    ["rust"] = { "rustfmt" },
    ["python"] = { "autoimport", "isort", "black" },
    ["zsh"] = { "shfmt" },
    ["sh"] = { "shfmt" },
    ["go"] = { "gofmt", "goimports" },
    ["markdown"] = { "prettier" },
    ["vue"] = { "prettier" },
    ["yaml"] = { "prettier" },
    ["ansible"] = { "prettier" },
    ["puppet"] = { "puppetlint" },
    ["java"] = { "google_java_format" },
    ["lua"] = { "lua-format", "stylua" },
}
vim.g["ale_fix_on_save"] = 1
vim.g["ale_go_gofmt_options"] = "-s"
vim.g["ale_go_gometalinter_options"] = "--fast"
vim.g["ale_go_golangci_lint_options"] = "--fast"
vim.g["ale_go_golangci_lint_package"] = 1
vim.g["ale_rust_cargo_use_clippy"] = 1
vim.g["ale_rust_analyzer_config"] = {
    ["rust-analyzer"] = {
        ["assist"] = {
            ["importMergeBehavior"] = "last",
            ["importPrefix"] = "by_self",
        },
        ["cargo.loadOutDirsFromCheck"] = true,
        ["procMacro.enable"] = true,
    },
}
vim.g["ale_linters"] = {
    ["go"] = { "golangci-lint", "gobuild", "golint" },
    ["rust"] = { "cargo", "rls" },
    ["typescript"] = { "tslint", "tsserver", "typecheck" },
}
vim.g["ale_completion_enabled"] = 1
vim.g["ale_echo_msg_error_str"] = "E"
vim.g["ale_echo_msg_warning_str"] = "W"
vim.g["ale_echo_msg_format"] = "[%linter%] [%severity%] %code = %%s "

-- alt k & j to jump through errors
utils.map { "n", "<M-k>", "<Plug>(ale_previous_wrap)" }
utils.map { "n", "<M-j>", "<Plug>(ale_next_wrap)" }

-- Disable for minified code and enable whitespace trimming
vim.g["ale_pattern_options"] = {
    [".min.js$"] = { ["ale_linters"] = {}, ["ale_fixers"] = {} },
    [".min.css$"] = { ["ale_linters"] = {}, ["ale_fixers"] = {} },
    ["*"] = { ["ale_fixers"] = { "trim_whitespace", "remove_trailing_lines" } },
}

vim.g["ale_set_loclist"] = 0
vim.g["ale_set_quickfix"] = 1

-- Define :ALEToggleFixer command to Disable autofix globally
vim.cmd [[
  command! ALEToggleFixer execute "let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0) ? 0 : 1"
]]
