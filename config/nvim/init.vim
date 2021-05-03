runtime system.vim

" Plug initialization
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup Plugins
    au!
    au VimEnter * PlugInstall | source $MYVIMRC
  augroup END
endif
call plug#begin('~/.local/share/nvim')
  runtime plug.vim
call plug#end()
if exists('veonim')
  runtime veonim.vim
endif

if has('autocmd')
  "Set leader to space
  let g:mapleader = "\<Space>"
  filetype plugin indent on
endif

if has('syntax')
  " Use syntax highlighting
  if !exists('g:syntax_on')
    syntax enable
  endif
  " Use my colorscheme if using the GUI or if we have 256 colors
  if has('gui_running') || &t_Co >= 256
    silent! color monokai
  endif
  " If not monokai, then default with dark background
  if !exists('g:colors_name')
    set background=dark
  endif
endif

" Use UTF-8 if we can and env LANG didn't tell us not to
if has('multi_byte') && !exists('$LANG') && &encoding ==# 'latin1'
  set encoding=utf-8
endif

" The all-important default indent settings; filetypes to tweak
set autoindent     " Use indent of previous line on new lines
set expandtab      " Use spaces instead of tabs
set shiftwidth=2   " Indent with two spaces
set softtabstop=2  " Insert two spaces with tab key
set cindent shiftwidth=2

" Let me backspace over pretty much anything
set backspace=2

" Indent wrapped lines
silent! set breakindent

" Give me a prompt instead of just rejecting risky :write, :saveas
set confirm

" Clear default 'comments' value, let the filetype handle it
set comments=

" Add completion options
if exists('+completeopt')
  set completeopt+=longest  " Insert longest common substring
  set completeopt+=menuone  " Show the menu even if only one match
endif


" Use UTF-8 if we can and env LANG didn't tell us not to
if has('multi_byte') && !exists('$LANG') && &encoding ==# 'latin1'
  set encoding=utf-8
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

" Don't assume I'm editing C; let the filetype set this
set include=

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

" Wildmenu settings; see also plugin/wildignore.vim
set wildmenu                " Use wildmenu
"set wildmode=list:longest   " Tab press completes and lists
silent! set wildignorecase  " Case insensitive, if supported

" Let me move beyond buffer text in visual block mode
if exists('+virtualedit')
  set virtualedit+=block
endif


set diffopt=filler,iwhite
set fileencoding=utf-8
set fillchars+=stl:\ ,stlnc:\
set foldcolumn=1
set foldlevel=0
set foldmethod=indent
set ignorecase
set laststatus=2
set linebreak
set list lcs=tab:\|\
set noerrorbells vb t_vb=
set nofoldenable
set number
set omnifunc=syntaxcomplete#Complete
set scrolloff=1
set showcmd
set showmatch
set smartcase
set softtabstop=2
set tabstop=2
set termencoding=utf-8

" Stop C-r from being seen ad backspace
nnoremap <silent> <BS> :TmuxNavigateLeft<cr>

" \R reloads ~/.vimrc
nnoremap <Bslash>R :<C-U>source $MYVIMRC<CR>

" \DEL deletes the current buffer
nnoremap <Bslash><Delete> :bdelete<CR>
" \INS edits a new buffer
nnoremap <Bslash><Insert> :<C-U>enew<CR>

" \/ types :vimgrep for me ready to enter a search pattern
nnoremap <Bslash>/ :<C-U>vimgrep /\c/ **<S-Left><S-Left><Right>

" \p toggles paste mode
nnoremap <Bslash>p :<C-U>set paste! paste?<CR>
