" OpenSSH configuration
autocmd BufNewFile,BufRead
      \ ssh_config,*/.ssh/config
      \ setfiletype sshconfig

" OpenSSH server configuration
autocmd BufNewFile,BufRead
      \ sshd_config
      \ setfiletype sshdconfig
