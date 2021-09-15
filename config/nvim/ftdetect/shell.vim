" Bash shell
autocmd BufNewFile,BufRead
      \ ?*.bash
      \,.bash_aliases
      \,.bash_completion
      \,.bash_logout
      \,.bash_profile
      \,.bashrc
      \,bash-fc.?*
      \,bash_aliases
      \,bash_completion
      \,bash_logout
      \,bash_profile
      \,bashrc
      \ let b:is_bash = 1
      \|setfiletype sh

" Korn shell
autocmd BufNewFile,BufRead
      \ ?*.ksh
      \,.kshrc
      \,kshrc
      \ let b:is_kornshell = 1
      \|setfiletype sh

" POSIX/Bourne shell
autocmd BufNewFile,BufRead
      \ ?*.sh
      \,$ENV
      \,.profile
      \,.shinit
      \,.shrc
      \,.xinitrc
      \,/etc/default/*
      \,configure
      \,profile
      \,shinit
      \,shrc
      \,xinitrc
      \ let b:is_posix = 1
      \|setfiletype sh
