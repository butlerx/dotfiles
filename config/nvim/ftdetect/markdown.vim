" Markdown files
autocmd BufNewFile,BufRead
      \ ?*.markdown
      \,?*.md
      \ setfiletype markdown
