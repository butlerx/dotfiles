-- Project-local tool resolution: when a repo ships its own copy of a tool, that
-- copy wins over the global (mason/homebrew/mise-global) install.
--
-- Every lookup is bounded by the project root, and that bound is load-bearing
-- rather than tidiness: `bin_dirs` includes a bare `bin`, so an unbounded upward
-- walk would match `/bin` and `~/bin` and report system tools as project-local.
-- Outside a project `ancestors()` returns nothing, and callers fall back to $PATH.

local M = {}
local uv = vim.uv

-- Search boundary. VCS markers win outright: in a monorepo that puts the root at
-- the top level, which is where `node_modules/.bin` actually lives.
M.vcs_markers = { ".git", ".hg", ".svn" }

-- Fallback boundary for projects that aren't under version control.
M.manifest_markers = {
  "package.json",
  "Cargo.toml",
  "go.mod",
  "go.work",
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Gemfile",
  "composer.json",
  "cpanfile",
  "Makefile",
  "flake.nix",
}

-- Where a repo puts executables it installs for itself, relative to any ancestor
-- up to the project root.
M.bin_dirs = {
  "node_modules/.bin", -- npm/pnpm/yarn
  ".venv/bin", -- uv/venv
  "venv/bin",
  ".tox/bin",
  "vendor/bin", -- composer, carton
  "local/bin", -- perl local::lib
  ".bin",
  "bin",
  "tools/bin",
  "script",
}

-- Presence of any of these means the repo pins tool versions with mise/asdf, so
-- `mise which` is the authority on which binary to run.
M.mise_markers = {
  "mise.toml",
  ".mise.toml",
  "mise.local.toml",
  ".mise.local.toml",
  "mise/config.toml",
  ".config/mise/config.toml",
  ".tool-versions",
}

local function is_exec(path)
  local stat = uv.fs_stat(path)
  if not stat or stat.type == "directory" then
    return false
  end
  return uv.fs_access(path, "X") == true
end

local function dir_of(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr or 0)
  if name == "" then
    return vim.fn.getcwd()
  end
  return vim.fs.dirname(vim.fs.normalize(name))
end

---Project root for a path: nearest VCS root, else nearest manifest directory.
---@param path? string file or directory to search upward from
---@return string|nil
function M.root(path)
  path = path and vim.fs.normalize(path) or dir_of(0)
  return vim.fs.root(path, M.vcs_markers) or vim.fs.root(path, M.manifest_markers)
end

---Ancestors of `path`, nearest first, stopping at the project root (inclusive).
---Returns an empty list when `path` isn't inside a project at all, which is what
---keeps the search from wandering into `/bin` or `$HOME`.
---@param path? string
---@return string[]
function M.ancestors(path)
  local dir = path and vim.fs.normalize(path) or dir_of(0)
  local root = M.root(dir)
  if not root then
    return {}
  end

  local out = {}
  local cur = dir
  while cur and cur ~= "" do
    table.insert(out, cur)
    if cur == root then
      break
    end
    local parent = vim.fs.dirname(cur)
    if parent == cur then
      break
    end
    cur = parent
  end
  return out
end

-- mise shells out, so its answers are cached per (dir, cmd) for the session.
-- `:LocalTools refresh` clears it after a `mise install`.
local mise_cache = {}

---@param cmd string
---@param dir string
---@return string|nil
function M.mise_which(cmd, dir)
  local marker
  for _, ancestor in ipairs(M.ancestors(dir)) do
    for _, name in ipairs(M.mise_markers) do
      if uv.fs_stat(ancestor .. "/" .. name) then
        marker = ancestor
        break
      end
    end
    if marker then
      break
    end
  end
  if not marker or vim.fn.executable("mise") == 0 then
    return nil
  end

  local key = marker .. "\0" .. cmd
  local hit = mise_cache[key]
  if hit ~= nil then
    return hit or nil -- `false` is a cached miss
  end

  local out = vim.system({ "mise", "which", cmd }, { cwd = marker, text = true }):wait()
  local path = out.code == 0 and vim.trim(out.stdout) or ""
  local resolved = (path ~= "" and is_exec(path)) and path or false
  mise_cache[key] = resolved
  return resolved or nil
end

---Locate a project-local executable for `cmd`.
---@param cmd string executable name, e.g. "prettier"
---@param opts? { dir?: string, paths?: string[], bin_dirs?: string[], mise?: boolean }
---  paths: extra repo-relative candidates tried before `bin_dirs`
---  mise: set false to skip the mise lookup
---@return string|nil absolute path, or nil if the repo doesn't ship it
function M.find_bin(cmd, opts)
  opts = opts or {}
  local dir = opts.dir or dir_of(0)

  for _, ancestor in ipairs(M.ancestors(dir)) do
    for _, rel in ipairs(opts.paths or {}) do
      local path = ancestor .. "/" .. rel
      if is_exec(path) then
        return path
      end
    end
    for _, bin in ipairs(opts.bin_dirs or M.bin_dirs) do
      local path = ancestor .. "/" .. bin .. "/" .. cmd
      if is_exec(path) then
        return path
      end
    end
  end

  if opts.mise ~= false then
    return M.mise_which(cmd, dir)
  end
end

---Project-local path for `cmd`, falling back to the bare name for `$PATH` lookup.
---Use this for `makeprg`, `equalprg` and anything else that wants a string now.
---@param cmd string
---@param opts? table see `find_bin`
---@return string
function M.exe(cmd, opts)
  return M.find_bin(cmd, opts) or cmd
end

---First directory matching one of `names`, searching upward to the project root.
---For plugins that take a bin *directory* rather than a binary path.
---@param names string[] repo-relative directory names, most specific first
---@param dir? string
---@return string|nil
function M.find_dir(names, dir)
  for _, ancestor in ipairs(M.ancestors(dir)) do
    for _, name in ipairs(names) do
      local path = ancestor .. "/" .. name
      local stat = uv.fs_stat(path)
      if stat and stat.type == "directory" then
        return path
      end
    end
  end
end

---Like `exe`, but safe to embed in a shell-interpreted option such as `makeprg`
---or `equalprg`, where an unquoted space in the path would split the argument.
---@param cmd string
---@param opts? table see `find_bin`
---@return string
function M.shell_exe(cmd, opts)
  local path = M.exe(cmd, opts)
  if path:find("[^%w@%%_%-%+=:,%./]") then
    return vim.fn.shellescape(path)
  end
  return path
end

---conform.nvim `command` resolver: re-resolves per format, per buffer.
---@param cmd string
---@param opts? table see `find_bin`
---@return fun(self: table, ctx: table): string
function M.formatter_cmd(cmd, opts)
  return function(_, ctx)
    local merged = vim.tbl_extend("force", opts or {}, { dir = ctx.dirname })
    return M.exe(cmd, merged)
  end
end

---Swap argv[1] for a project-local binary of the same name, leaving args alone.
---Only bare names are substituted, so `{ "node", "server.js" }` is left as-is
---rather than resolving the interpreter.
---@param argv string[]
---@param dir? string
---@return string[]
function M.localize_argv(argv, dir)
  if type(argv) ~= "table" or #argv == 0 then
    return argv
  end
  local head = argv[1]
  if type(head) ~= "string" or head:find("/", 1, true) then
    return argv
  end

  local local_bin = M.find_bin(head, { dir = dir })
  if not local_bin then
    return argv
  end

  local out = vim.deepcopy(argv)
  out[1] = local_bin
  return out
end

---Report what would be used for `cmd` from the current buffer.
---@param cmd string
---@return string path, boolean is_local
function M.inspect(cmd)
  local found = M.find_bin(cmd)
  return found or vim.fn.exepath(cmd), found ~= nil
end

function M.clear_cache()
  mise_cache = {}
end

return M
