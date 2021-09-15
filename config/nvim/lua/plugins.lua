-- load vim-plug if it does not exist in the dotfiles
vim.cmd [[
    let plugpath = '~/.local/share/nvim/site/autoload/plug.vim'
    if empty(glob(plugpath))
        if executable('curl')
            echom "Installing vim-plug at " . plugpath
            let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
            call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
            if v:shell_error
                echom "Error downloading vim-plug. Please install it manually.\n"
                exit
            endif
            augroup Plugins
              au!
              au VimEnter * PlugInstall | source $MYVIMRC
        else
            echom "vim-plug not installed. Please install it manually or install curl.\n"
            exit
        endif
    endif
]]

local Plug = vim.fn["plug#"]
vim.call("plug#begin", "~/.local/share/nvim")

Plug "Yggdroot/indentLine"
Plug("cespare/vim-toml", { ["for"] = "toml" })
Plug("chrisbra/csv.vim", { ["for"] = "csv" })
Plug "christoomey/vim-tmux-navigator"
Plug "dense-analysis/ale"
Plug "nathanmsmith/nvim-ale-diagnostic"
Plug("ekalinin/Dockerfile.vim", { ["for"] = [['Dockerfile', 'docker-compose']] })
Plug "elzr/vim-json"
Plug("fatih/vim-go", { ["do"] = ":GoInstallBinaries", ["for"] = [['go', 'gohtmltmpl']] })
Plug "godlygeek/tabular"
Plug "plasticboy/vim-markdown"
Plug "google/vim-jsonnet"
Plug "gregsexton/gitv"
Plug "hashivim/vim-terraform"
Plug "hrsh7th/nvim-cmp"
Plug "hrsh7th/vim-vsnip"
Plug "hrsh7th/cmp-buffer"
Plug("leafgarland/typescript-vim", {
    ["for"] = [['typescript.tsx', 'typescriptreact', 'typescript',
    'vue']],
})
Plug "mhinz/vim-signify"
Plug "mhinz/vim-startify"
Plug "moll/vim-node"
Plug "neovim/nvim-lspconfig"
Plug "kabouzeid/nvim-lspinstall"
Plug("nvim-treesitter/nvim-treesitter", { ["branch"] = "0.5-compat", ["do"] = ":TSUpdate" })
Plug("pangloss/vim-javascript", { ["for"] = [['typescript.tsx', 'typescriptreact', 'javascript', 'vue']] })
Plug("racer-rust/vim-racer", { ["for"] = "rust" })
Plug "rodjek/vim-puppet"
Plug("rust-lang/rust.vim", { ["for"] = "rust" })
Plug "ryanoasis/vim-devicons"
Plug "scrooloose/nerdcommenter"
Plug "scrooloose/nerdtree"
Plug "Xuyuanp/nerdtree-git-plugin"
Plug "sheerun/vim-polyglot"
Plug "sickill/vim-monokai"
Plug "tpope/vim-fugitive"
Plug "tpope/vim-surround"
Plug "vim-airline/vim-airline"
Plug "vim-airline/vim-airline-themes"

vim.call "plug#end"
