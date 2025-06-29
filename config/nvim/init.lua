local utils = require("utils")
local set = vim.opt
local fn = vim.fn
local map = utils.map

vim.cmd([[runtime system.vim]])
require("plugins")

if fn.has("autocmd") then
    -- Set leader to space
    vim.g.mapleader = " "
    vim.cmd([[filetype plugin indent on]])
end
if fn.has("syntax") then
    -- Use syntax highlighting
    if not vim.g.syntax_on then
        vim.cmd([[syntax enable]])
    end
    -- Use my colorscheme if using the GUI or if we have 256 colors
    if vim.api.nvim_eval("&t_Co >= 256") then
        vim.cmd([[color monokai]])
    end
    -- If not monokai, then default with dark background
    if not vim.g.colors_name then
        vim.o.background = "dark"
    end
end

-- Use UTF-8 if we can and env LANG didn't tell us not to
if fn.has("multi_byte") and not fn.exists("$LANG") and vim.api.nvim_eval("&encoding") == "latin1" then
    set.encoding = "utf-8"
end

-- The all-important default indent settings; filetypes to tweak
set.autoindent = true -- Use indent of previous line on new lines
set.expandtab = true -- Use spaces instead of tabs
set.shiftwidth = 2 -- Indent with two spaces
set.softtabstop = 2 -- Insert two spaces with tab key
set.smartindent = true -- Enable smart-indent
set.smarttab = true -- Enable smart-tabs
set.tabstop = 2
set.cindent = true
set.backspace = { "indent", "eol", "start" } -- Let me backspace over pretty much anything
set.clipboard = { "unnamed", "unnamedplus" } -- use the system clipboard
set.breakindent = true -- Indent wrapped lines
set.confirm = true -- Give me a prompt instead of just rejecting risky :write, :saveas
set.comments = "" -- Clear default 'comments' value, let the filetype handle it

-- Add completion options
set.completeopt:append({
    "noinsert",
    "longest", -- Insert longest common substring
    "menuone", -- Show the menu even if only one match
    "noselect", -- Show the menu even if only one match
})

-- Fold based on indent, but only when I ask
if fn.has("folding") then
    set.foldlevelstart = 99
    set.foldenable = false
    set.foldcolumn = "1"
    set.foldlevel = 0
    set.foldmethod = "expr"
    set.foldexpr = "nvim_treesitter#foldexpr()"
end

-- Delete comment leaders when joining lines, if supported
set.formatoptions:append({ "j" })

-- If available, use GNU grep niceties for searching
if fn.system("grep --version") ~= "^grep (GNU grep)" then
    set.grepprg = "grep -HnRs --exclude='.git*'"
end

-- Allow buffers to have changes without being displayed
set.hidden = true

-- Keep much more command and search history
set.history = 2000

-- Highlight completed searches; clear on reload
vim.cmd([[
  set hlsearch
  if 1
    nohlsearch
  endif
]])

set.include = "" -- Don't assume I'm editing C; let the filetype set this
set.incsearch = true -- Show search matches as I type my pattern
set.joinspaces = false -- Don't join lines with two spaces at the end of sentences
set.lazyredraw = true -- Don't redraw the screen during batch execution
set.linebreak = true -- Break lines at word boundaries

-- Show row and column ruler information
set.ruler = true
set.colorcolumn = "120"

-- Options for file search with gf/:find
set.path:remove({ "/usr/include" }) -- Let the C/C++ filetypes set that
set.path:append({ "**" }) -- Search current directory's whole tree

-- Prefix wrapped rows with three dots
set.showbreak = "..."

-- New windows go below or to the right of a split
set.splitbelow = true
set.splitright = true

-- Give me a bit longer to complete mappings
set.timeout = false
set.ttimeout = false
set.timeoutlen = 10000
set.ttimeoutlen = 10000

-- Keep undo files, hopefully in a dedicated directory
if fn.has("persistent_undo") then
    set.undofile = true
end

-- Number of undo levels
set.undolevels = 1000

-- Wildmenu settings; see also plugin/wildignore.vim
set.wildmenu = true -- Use wildmenu
set.wildignorecase = true -- Case insensitive, if supported

-- Let me move beyond buffer text in visual block mode
if fn.exists("+virtualedit") then
    set.virtualedit:append({ "block" })
end

set.diffopt = "filler,iwhite"
set.fileencoding = "utf-8"
vim.cmd([[set fillchars+=stl:\ ,stlnc:\ ]])
set.ignorecase = true -- Always case-insensitive
set.laststatus = 2
set.linebreak = true -- Break lines at word (requires Wrap lines)
set.list = true
set.listchars = { tab = "❯ ", trail = "⋅", extends = "❯", precedes = "❮" }
vim.cmd([[set noerrorbells vb t_vb=]])
set.number = true -- Show line numbers
set.omnifunc = "syntaxcomplete#Complete"
set.scrolloff = 1
set.showcmd = true
set.showmatch = true -- Highlight matching brace
set.smartcase = true -- Enable smart-case search
--vim.cmd([[set termencoding=utf-8]])
set.visualbell = true -- Use visual bell (no beeping)

-- Delete Selected word from whole file
map({ "n", "<Leader>s", ":%s/<C-r><C-w>//g<Left><Left>" })
-- Stop C-r from being seen as backspace
map({ "n", "<BS>", ":TmuxNavigateLeft<cr>" })
-- \R reloads ~/.vimrc
map({ "n", "<Bslash>R", ":<C-U>source $MYVIMRC<CR>" })
-- \DEL deletes the current buffer
map({ "n", "<Bslash><Delete>", ":bdelete<CR>" })
-- \INS edits a new buffer
map({ "n", "<Bslash><Insert>", ":<C-U>enew<CR>" })
-- \/ types :vimgrep for me ready to enter a search pattern
map({ "n", "<Bslash>/", ":<C-U>vimgrep /c/ **<S-Left><S-Left><Right>" })
-- \p toggles paste mode
map({ "n", "<Bslash>p", ":<C-U>set paste! paste?<CR>" })
