Plug 'Yggdroot/indentLine'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'chrisbra/csv.vim', { 'for': 'csv' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'ekalinin/Dockerfile.vim', { 'for': ['Dockerfile', 'docker-compose'] }
Plug 'elzr/vim-json',
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': ['go', 'gohtmltmpl'] }
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
Plug 'gregsexton/gitv'
Plug 'isobit/vim-caddyfile'
Plug 'leafgarland/typescript-vim'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-startify'
Plug 'moll/vim-node'
Plug 'mustache/vim-mustache-handlebars'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'posva/vim-vue'
if !has('nvim')
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'ncm2/ncm2' |
  Plug 'ncm2/ncm2-tern',  {'do': 'npm install'} |
  Plug 'filipekiss/ncm2-look.vim'|
  Plug 'mhartington/nvim-typescript', {'do': './install.sh'} |
  Plug 'ncm2/ncm2-bufword' |
  Plug 'ncm2/ncm2-cssomni'|
  Plug 'ncm2/ncm2-github' |
  Plug 'ncm2/ncm2-go', {'do': 'go get -u github.com/mdempsky/gocode' }|
  Plug 'ncm2/ncm2-html-subscope'|
  Plug 'ncm2/ncm2-jedi'|
  Plug 'ncm2/ncm2-markdown-subscope'|
  Plug 'ncm2/ncm2-path' |
  Plug 'ncm2/ncm2-racer'|
  Plug 'ncm2/ncm2-tagprefix'|
  Plug 'ncm2/ncm2-tmux' |
  Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'|
  Plug 'roxma/ncm-flow'
  Plug 'roxma/nvim-yarp' |
  Plug 'wellle/tmux-complete.vim'|
  Plug 'yuki-ycino/ncm2-dictionary'|
Plug 'ryanoasis/vim-devicons'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'sheerun/vim-polyglot'
Plug 'sickill/vim-monokai'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'udalov/kotlin-vim'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
Plug 'w0rp/ale'
Plug 'c9s/helper.vim'
Plug 'c9s/treemenu.vim'
Plug 'c9s/vikube.vim'
" vim: set syntax=vim:
