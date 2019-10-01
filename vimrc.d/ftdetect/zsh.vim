" Z shell files
autocmd BufNewFile,BufRead
      \ ?*.zsh
      \,.zprofile
      \,.zshrc
      \,zprofile
      \,zshrc
      \ setfiletype zsh
