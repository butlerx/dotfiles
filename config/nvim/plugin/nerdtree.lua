local utils = require "utils"
local g = vim.g
local call = vim.call

local autocmds = {
    NERDTree = {
        { "StdinReadPre", "*", "let s:std_in=1" },
        {
            "BufEnter",
            "*",
            "if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif",
        },
        {
            "VimEnter",
            "*",
            [[if !argc() && !exists('s:std_in') | Startify | NERDTree | wincmd w | else | NERDTree | wincmd w | endif]],
        },
    },
}

utils.create_augroups(autocmds)
utils.map { "", "<C-n>", ":NERDTreeToggle<CR>" }

g.NERDTreeDirArrowExpandable = "▸"
g.NERDTreeDirArrowCollapsible = "▾"
g.NERDTreeGitStatusIndicatorMapCustom = {
    ["Modified"] = "✹",
    ["Staged"] = "✚",
    ["Untracked"] = "✭",
    ["Renamed"] = "➜",
    ["Unmerged"] = "═",
    ["Deleted"] = "✖",
    ["Dirty"] = "✗",
    ["Clean"] = "✔︎",
    ["Unknown"] = "?",
}
-- NERDTress File highlighting
vim.cmd [[
  function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
  endfunction
]]

call("NERDTreeHighlightFile", "jade", "green", "none", "green", "#151515")
call("NERDTreeHighlightFile", "ini", "yellow", "none", "yellow", "#151515")
call("NERDTreeHighlightFile", "md", "blue", "none", "#3366FF", "#151515")
call("NERDTreeHighlightFile", "yml", "yellow", "none", "yellow", "#151515")
call("NERDTreeHighlightFile", "config", "yellow", "none", "yellow", "#151515")
call("NERDTreeHighlightFile", "conf", "yellow", "none", "yellow", "#151515")
call("NERDTreeHighlightFile", "json", "yellow", "none", "yellow", "#151515")
call("NERDTreeHighlightFile", "html", "yellow", "none", "yellow", "#151515")
call("NERDTreeHighlightFile", "styl", "cyan", "none", "cyan", "#151515")
call("NERDTreeHighlightFile", "css", "cyan", "none", "cyan", "#151515")
call("NERDTreeHighlightFile", "coffee", "Red", "none", "red", "#151515")
call("NERDTreeHighlightFile", "js", "Red", "none", "#ffa500", "#151515")
call("NERDTreeHighlightFile", "php", "Magenta", "none", "#ff00ff", "#151515")
