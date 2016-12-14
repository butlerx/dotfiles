" Plug initialization
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim')
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all' }
Plug 'Yggdroot/indentLine'
Plug 'chrisbra/csv.vim', { 'for': 'csv' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'godlygeek/tabular'
Plug 'gregsexton/gitv'
Plug 'honza/vim-snippets'
Plug 'jimmyhchan/dustjs.vim', { 'for': 'dustjs' }
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-startify'
Plug 'moll/vim-node'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/syntastic'
Plug 'shime/vim-livedown', { 'for': 'markdown' }
Plug 'sickill/vim-monokai'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
call plug#end()

syntax enable
filetype plugin on
colorscheme monokai
set autoindent
set background=dark
set backspace=2
set cindent shiftwidth=2
set diffopt=filler,iwhite
set encoding=utf-8
set expandtab
set fileencoding=utf-8
set fillchars+=stl:\ ,stlnc:\
set foldcolumn=1
set foldlevel=0
set foldmethod=indent
set guioptions+=LlRrb
set guioptions-=LlRrb
set guioptions-=T
set guioptions-=m
set hidden
set history=50
set ignorecase
set incsearch
set laststatus=2
set linebreak
set mouse=""
set nocompatible
set noeb vb t_vb=
set nofen
set notimeout
set nottimeout
set number
set omnifunc=syntaxcomplete#Complete
set ruler
set scrolloff=1
set shiftwidth=2
set showcmd
set showmatch
set smartcase
set softtabstop=2
set t_Co=256
set tabstop=2
set termencoding=utf-8
set timeoutlen=10000
set ttimeoutlen=10000
set virtualedit=block
set wildmenu
" Stop C-r from being seen ad backspace
nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
"Set leader to space
let mapleader = "\<Space>"
" Symtastic settings
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_mode_map = { 'mode': 'active',
  \ 'active_filetypes': [],
  \ 'passive_filetypes': ['html'] }
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" vim-json
let g:vim_json_syntax_conceal = 0
" Delete Selected word from whole file
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
" Highlight white space at the end of a line
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" vim airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_alt_sep = '|'
" YouCompleteMe
let g:ycm_server_python_interpreter = '/usr/bin/python'
"Nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter *
  \   if !argc() && !exists("s:std_in")
  \ |   Startify
  \ |   NERDTree
  \ |   wincmd w
  \ | else
  \ |   NERDTree
  \ |   wincmd w
  \ | endif
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeIndicatorMapCustom = {
  \ "Modified"  : "✹",
  \ "Staged"    : "✚",
  \ "Untracked" : "✭",
  \ "Renamed"   : "➜",
  \ "Unmerged"  : "═",
  \ "Deleted"   : "✖",
  \ "Dirty"     : "✗",
  \ "Clean"     : "✔︎",
  \ "Unknown"   : "?"
  \ }
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('jade'   , 'green'   , 'none' , 'green'   , '#151515')
call NERDTreeHighlightFile('ini'    , 'yellow'  , 'none' , 'yellow'  , '#151515')
call NERDTreeHighlightFile('md'     , 'blue'    , 'none' , '#3366FF' , '#151515')
call NERDTreeHighlightFile('yml'    , 'yellow'  , 'none' , 'yellow'  , '#151515')
call NERDTreeHighlightFile('config' , 'yellow'  , 'none' , 'yellow'  , '#151515')
call NERDTreeHighlightFile('conf'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
call NERDTreeHighlightFile('json'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
call NERDTreeHighlightFile('html'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
call NERDTreeHighlightFile('styl'   , 'cyan'    , 'none' , 'cyan'    , '#151515')
call NERDTreeHighlightFile('css'    , 'cyan'    , 'none' , 'cyan'    , '#151515')
call NERDTreeHighlightFile('coffee' , 'Red'     , 'none' , 'red'     , '#151515')
call NERDTreeHighlightFile('js'     , 'Red'     , 'none' , '#ffa500' , '#151515')
call NERDTreeHighlightFile('php'    , 'Magenta' , 'none' , '#ff00ff' , '#151515')
" Force syntax for template files
au BufRead,BufNewFile *.ejs setfiletype javascript
" Spell check markdown and limit to 80 charcters
au BufRead,BufNewFile *.txt setlocal textwidth=80
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
set complete+=kspell
" See line indentation
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#A4E57E'
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)
" Define :Hipster command to dump in a paragraph of Hipster ipsum
command! -nargs=0 Hipster :normal iTrust fund fashion axe bitters art party
  \ raw denim. XOXO distillery tofu, letterpress cred literally gluten-free
  \ flexitarian fap. VHS fashion axe gluten-free 90's church-key, kogi
  \ hashtag Marfa. Kogi Tumblr Brooklyn chambray. Flannel pickled YOLO
  \ semiotics. Mlkshk keffiyeh narwhal, mumblecore gentrify raw denim food
  \ truck DIY. Craft beer chia readymade ethnic, hella kogi Vice jean shorts
  \ cliche cray mlkshk ugh cornhole kitsch quinoa
