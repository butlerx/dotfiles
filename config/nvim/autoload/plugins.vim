" load vim-plug if it does not exist in the dotfiles
function! plugins#PlugLoad()
    let plugFile =  stdpath('data') . '/site/autoload/plug.vim'
    if empty(glob(plugFile))
        if executable('curl')
            echom 'Installing vim-plug at ' . plugFile
            let plugURL = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
            if v:shell_error
                echom "Error downloading vim-plug. Please install it manually.\n"
                exit
            endif
            silent execute '!curl -fLo ' . plugFile . ' --create-dirs ' . plugURL
            augroup pluginstall
                autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
            augroup END
        else
            echom "vim-plug not installed. Please install it manually or install curl.\n"
            exit
        endif
    endif
endfunction

augroup autoinstallplugins
    autocmd!
    autocmd VimEnter *
        \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \|   PlugInstall --sync | q
        \| endif
augroup END
