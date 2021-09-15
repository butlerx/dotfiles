" crontab(5) files
autocmd BufNewFile,BufRead
      \ crontab
      \,crontab.*
      \,cron.d/*
      \ setfiletype crontab
