-- Introspection for project-local tool resolution.
--
--   :LocalTools            what the current buffer's project resolves
--   :LocalTools prettier   resolve one tool by name
--   :LocalTools refresh    drop cached `mise which` answers (after `mise install`)

local project = require("project")

-- Just the list `:LocalTools` walks with no argument. Nothing reads it but the
-- report, so adding or removing a name here changes nothing else.
local known = {
  "prettier",
  "eslint_d",
  "eslint",
  "stylelint",
  "fixjson",
  "typescript-language-server",
  "ruff",
  "ty",
  "stylua",
  "lua-language-server",
  "selene",
  "rustfmt",
  "rust-analyzer",
  "gofumpt",
  "goimports",
  "gopls",
  "golangci-lint",
  "shfmt",
  "shellcheck",
  "yamlfmt",
  "tombi",
  "terraform",
  "tflint",
  "perltidy",
  "perlcritic",
  "vint",
  "tidy",
  "jq",
}

local function report(names)
  local root = project.root()
  local lines = { "Project root: " .. (root or "(none — local resolution disabled)") }

  for _, name in ipairs(names) do
    local path, is_local = project.inspect(name)
    if path ~= "" then
      lines[#lines + 1] = string.format("%s %-28s %s", is_local and "local " or "global", name, path)
    elseif #names == 1 then
      lines[#lines + 1] = string.format("%s %-28s not found", "  --  ", name)
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("LocalTools", function(opts)
  local arg = vim.trim(opts.args)
  if arg == "refresh" then
    project.clear_cache()
    vim.notify("LocalTools: cache cleared", vim.log.levels.INFO)
  elseif arg ~= "" then
    report({ arg })
  else
    report(known)
  end
end, {
  nargs = "?",
  complete = function(lead)
    local out = vim.tbl_filter(function(name)
      return vim.startswith(name, lead)
    end, vim.list_extend({ "refresh" }, known))
    return out
  end,
  desc = "Show which tool binaries this project resolves to",
})

-- A `mise install` or a switch between projects can invalidate cached lookups.
vim.api.nvim_create_autocmd("DirChanged", {
  group = vim.api.nvim_create_augroup("local_tools", { clear = true }),
  callback = function()
    project.clear_cache()
  end,
})
