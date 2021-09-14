local utils = require("utils")
local set = vim.opt
local map = utils.map

vim.cmd [[runtime system.vim]]
require('plugins')

if vim.api.nvim_eval("has('autocmd')") then
  -- Set leader to space
  vim.g.mapleader = " "
  vim.cmd [[filetype plugin indent on]]
end
if vim.api.nvim_eval("has('syntax')") then
  -- Use syntax highlighting
  if not vim.g.syntax_on then
    vim.cmd [[syntax enable]]
  end
  -- Use my colorscheme if using the GUI or if we have 256 colors
  if vim.api.nvim_eval("has('gui_running') || &t_Co >= 256") then
    vim.cmd [[silent! color monokai]]
  end
  -- If not monokai, then default with dark background
  if not vim.g.colors_name then
    vim.o.background = "dark"
  end
end

-- Use UTF-8 if we can and env LANG didn't tell us not to
if vim.api.nvim_eval("has('multi_byte') && !exists('$LANG') && &encoding ==# 'latin1'") then
  set.encoding = "utf-8"
end

-- The all-important default indent settings; filetypes to tweak
set.autoindent = true    -- Use indent of previous line on new lines
set.expandtab = true     -- Use spaces instead of tabs
set.shiftwidth = 2       -- Indent with two spaces
set.softtabstop = 2      -- Insert two spaces with tab key
set.smartindent = true   -- Enable smart-indent
set.smarttab = true      -- Enable smart-tabs
set.tabstop = 2
set.cindent = true

-- Let me backspace over pretty much anything
set.backspace = "indent,eol,start"
-- Indent wrapped lines
set.breakindent = true

-- Give me a prompt instead of just rejecting risky :write, :saveas
set.confirm = true

-- Clear default 'comments' value, let the filetype handle it
set.comments = ""

vim.cmd [[
    " Add completion options
    if exists('+completeopt')
      set completeopt+=noinsert
      set completeopt+=longest  " Insert longest common substring
      set completeopt+=menuone  " Show the menu even if only one match
      set completeopt+=noselect  " Show the menu even if only one match
    else
      set completeopt=noinsert,longest,menuone,noselect
    endif

    " Don't wait for a key after Escape in insert mode
    " In vim-tiny but not NeoVim, so just suppress errors
    silent! set noesckeys

    " Fold based on indent, but only when I ask
    if has('folding')
      set foldlevelstart=99
      set foldmethod=indent
    endif

    " Delete comment leaders when joining lines, if supported
    silent! set formatoptions+=j

    " If available, use GNU grep niceties for searching
    if system('grep --version') =~# '^grep (GNU grep)'
      set grepprg=grep\ -HnRs\ --exclude='.git*'
    endif

    " Don't load GUI menus; set here before GUI starts
    if has('gui_running')
      set guioptions+=M
      set guioptions+=LlRrb
      set guioptions-=LlRrb
      set guioptions-=T
      set guioptions-=m
    endif

    " Allow buffers to have changes without being displayed
    set hidden

    " Keep much more command and search history
    set history=2000

    " Highlight completed searches; clear on reload
    set hlsearch
    if 1
      nohlsearch
    endif
]]
-- Don't assume I'm editing C; let the filetype set this
set.include=""

vim.cmd [[
    " Show search matches as I type my pattern
    set incsearch

    " Don't join lines with two spaces at the end of sentences
    set nojoinspaces

    " Don't show a statusline if there's only one window
    " This is the Vim default, but NeoVim changed it
    if &laststatus != 1
      set laststatus=1
    endif

    " Don't redraw the screen during batch execution
    set lazyredraw

    " Break lines at word boundaries
    set linebreak

    " Disable command line display of file position
    " This is the Vim default, but NeoVim changed it
    if &ruler
      set noruler
    endif

    " Show row and column ruler information
    set ruler
    set colorcolumn=100

    " Options for file search with gf/:find
    set path-=/usr/include  " Let the C/C++ filetypes set that
    set path+=**            " Search current directory's whole tree

    " Prefix wrapped rows with three dots
    set showbreak=...

    " New windows go below or to the right of a split
    set splitbelow
    set splitright

    " Give me a bit longer to complete mappings
    set notimeout
    set nottimeout
    set timeoutlen=10000
    set ttimeoutlen=10000

    " No terminal mouse, even if we could
    silent! set ttymouse=

    " Keep undo files, hopefully in a dedicated directory
    if has('persistent_undo')
      set undofile
      set undodir^=~/.vim/cache/undo//
    endif
    set undolevels=1000 " Number of undo levels

    " Wildmenu settings; see also plugin/wildignore.vim
    set wildmenu                " Use wildmenu
    "set wildmode=list:longest   " Tab press completes and lists
    silent! set wildignorecase  " Case insensitive, if supported

    " Let me move beyond buffer text in visual block mode
    if exists('+virtualedit')
      set virtualedit+=block
    endif
]]

set.diffopt = "filler,iwhite"
set.fileencoding="utf-8"
vim.cmd [[set fillchars+=stl:\ ,stlnc:\ ]]
set.foldcolumn = "1"
set.foldlevel = 0
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
-- Always case-insensitive
set.ignorecase = true
set.laststatus = 2
-- Break lines at word (requires Wrap lines)
set.linebreak = true
vim.cmd [[
  set list lcs=tab:\|\
  set noerrorbells vb t_vb=
]]
set.foldenable = false
-- Show line numbers
set.number = true
set.omnifunc = "syntaxcomplete#Complete"
set.scrolloff = 1
set.showcmd = true
-- Highlight matching brace
set.showmatch = true
-- Enable smart-case search
set.smartcase = true
vim.cmd [[set termencoding=utf-8]]
-- Line wrap (number of cols)
set.textwidth = 100
-- Use visual bell (no beeping)
set.visualbell = true

-- Delete Selected word from whole file
map {'n', '<Leader>s', ':%s/<<C-r><C-w>>//g<Left><Left>'}

-- Stop C-r from being seen as backspace
map {'n', '<BS>', ':TmuxNavigateLeft<cr>'}

-- \R reloads ~/.vimrc
map {'n', '<Bslash>R', ':<C-U>source $MYVIMRC<CR>'}

-- \DEL deletes the current buffer
map {'n', '<Bslash><Delete>', ':bdelete<CR>'}

-- \INS edits a new buffer
map {'n', '<Bslash><Insert>', ':<C-U>enew<CR>'}

-- \/ types :vimgrep for me ready to enter a search pattern
map {'n', '<Bslash>/', ':<C-U>vimgrep /c/ **<S-Left><S-Left><Right>'}

-- \p toggles paste mode
map {'n', '<Bslash>p', ':<C-U>set paste! paste?<CR>'}
