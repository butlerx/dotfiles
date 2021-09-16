" Override system filetype.vim
if exists('g:did_load_filetypes')
  finish
endif
let g:did_load_filetypes = 1

" If we don't have +autocmd or are 'compatible', do nothing, and don't try
" again later
if !has('autocmd') || &compatible
  finish
endif

" Helper function to run the 'filetypedetect' group on a file with its
" extension stripped off
function! s:StripRepeat()

  " Check we have the fnameescape() function
  if !exists('*fnameescape')
    return
  endif

  " Expand the match result
  let l:fn = expand('<afile>')

  " Strip leading and trailing #hashes#
  if l:fn =~# '^#\+.*#\+$'
    let l:fn = substitute(l:fn, '^#\+\(.\+\)#\+$', '\1', '')

  " Strip trailing tilde~
  elseif l:fn =~# '\~$'
    let l:fn = substitute(l:fn, '\~$', '', '')

  " Strip generic .extension
  else
    let l:fn = expand('<afile>:r')
  endif

  " Re-run the group if there's anything left
  if strlen(l:fn)
    execute 'doautocmd filetypedetect BufRead ' . fnameescape(l:fn)
  endif

endfunction

" Check whether the first line was changed and looks like a shebang, and if
" so, re-run filetype detection
function! s:CheckShebang()
  if line('''[') == 1 && getline(1) =~# '^#!'
    doautocmd filetypedetect BufRead
  endif
endfunction

" Use our own filetype detection rules
augroup filetypedetect
  autocmd!

  " Unwrap hashes, tildes, generic extensions, and Debian packaging working
  " extensions (if we can do so safely), and repeat the filetype detection to
  " see if there's a match beneath them
  autocmd BufNewFile,BufRead
        \ #?*#
        \,?*~
        \,?*.{bak,example,in,new,old,orig,sample,test}
        \,?*.dpkg-{bak,dist,new,old}
        \ call s:StripRepeat()

  " CSS files
  autocmd BufNewFile,BufRead
        \ ?*.css
        \ setfiletype css
  " CSV files
  autocmd BufNewFile,BufRead
        \ ?*.csv
        \ setfiletype csv
  " Diff and patch files
  autocmd BufNewFile,BufRead
        \ ?*.diff
        \,?*.patch
        \,?*.rej
        \ setfiletype diff
  " INI files
  autocmd BufNewFile,BufRead
        \ ?*.ini
        \ setfiletype dosini
  " DOT graphs
  autocmd BufNewFile,BufRead
        \ ?*.dot
        \ setfiletype dot
  " Forth
  autocmd BufNewFile,BufRead
        \ ?*.fs,?*.ft
        \ setfiletype forth
  " fstab(5) files
  autocmd BufNewFile,BufRead
        \ fstab
        \ setfiletype fstab
  " GDB init files
  autocmd BufNewFile,BufRead
        \ .gdbinit
        \ setfiletype gdb
  " GnuPG configuration files
  autocmd BufNewFile,BufRead
        \ *gnupg/options
        \,*gnupg/gpg.conf
        \ setfiletype gpg
  " UNIX group file
  autocmd BufNewFile,BufRead
        \ /etc/group
        \,/etc/group-
        \,/etc/group.edit
        \,/etc/gshadow
        \,/etc/gshadow-
        \,/etc/gshadow.edit
        \ setfiletype group
  " GTK settings files
  autocmd BufNewFile,BufRead
        \ .gktrc*,
        \,gktrc*
        \ setfiletype gtkrc
  " inittab(5) files
  autocmd BufNewFile,BufRead
        \ inittab
        \ setfiletype inittab
  " Java files
  autocmd BufNewFile,BufRead
        \ ?*.java
        \,?*.jav
        \ setfiletype java
  " JSON files
  autocmd BufNewFile,BufRead
        \ ?*.json
        \ setfiletype json
  " Lex files
  autocmd BufNewFile,BufRead
        \ ?*.l
        \,?*.lex
        \ setfiletype lex
  " Lua files
  autocmd BufNewFile,BufRead
        \ ?*.lua
        \ setfiletype lua
  " m4 files
  autocmd BufNewFile,BufRead
        \ ?*.m4
        \ setfiletype m4
  " Makefiles
  autocmd BufNewFile,BufRead
        \ Makefile
        \,makefile
        \ setfiletype make
  " Mutt configuration files
  autocmd BufNewFile,BufRead
        \ Muttrc
        \,*/.muttrc.d/*.rc
        \,.muttrc
        \,/etc/Muttrc.d/*
        \ setfiletype muttrc
  " Nano configuration file
  autocmd BufNewFile,BufRead
        \ *.nanorc
        \,*/etc/nanorc
        \ setfiletype nanorc
  " netrc file
  autocmd BufNewFile,BufRead
        \ .netrc
        \,netrc
        \ setfiletype netrc
  " roff files
  autocmd BufNewFile,BufRead
        \ ?*.roff
        \,?*.[1-9]
        \,*/man[1-9]*/?*.[1-9]*
        \ setfiletype nroff
  " UNIX password and shadow files
  autocmd BufNewFile,BufRead
        \ /etc/passwd
        \,/etc/passwd-
        \,/etc/passwd.edit
        \,/etc/shadow
        \,/etc/shadow-
        \,/etc/shadow.edit
        \ setfiletype passwd
  " pass(1) password files
  autocmd BufNewFile,BufRead
        \ /dev/shm/pass.?*/?*.txt
        \,$TMPDIR/pass.?*/?*.txt
        \,/tmp/pass.?*/?*.txt
        \ setfiletype password
  " Python files
  autocmd BufNewFile,BufRead
        \ ?*.py
        \ setfiletype python
  " Readline configuration file
  autocmd BufNewFile,BufRead
        \ .inputrc
        \,inputrc
        \ setfiletype readline
  " Remind files
  autocmd BufNewFile,BufRead
        \ .reminders
        \,?*.rem
        \,?*.remind
        \ setfiletype remind
  " robots.txt files
  autocmd BufNewFile,BufRead
        \ robots.txt
        \ setfiletype robots
  " Ruby
  autocmd BufNewFile,BufRead
        \ ?*.rb
        \,Puppetfile
        \ setfiletype ruby
  " sed files
  autocmd BufNewFile,BufRead
        \ ?*.sed
        \ setfiletype sed
  " Services files
  autocmd BufNewFile,BufRead
        \ /etc/services
        \ setfiletype services
  " sudoers(5)
  autocmd BufNewFile,BufRead
        \ sudoers
        \,sudoers.tmp
        \ setfiletype sudoers
  " Subversion commit
  autocmd BufNewFile,BufRead
        \ svn-commit*.tmp
        \ setfiletype svn
  " Systemd unit files
  autocmd BufNewFile,BufRead
        \ */systemd/*.*
        \ setfiletype systemd
  " TCL
  autocmd BufNewFile,BufRead
        \ ?*.tcl
        \ setfiletype tcl
  " Terminfo
  autocmd BufNewFile,BufRead
        \ ?*.ti
        \ setf terminfo
  " Tidy config
  autocmd BufNewFile,BufRead
        \ .tidyrc
        \,tidyrc
        \ setfiletype tidy
  " tmux configuration files
  autocmd BufNewFile,BufRead
        \ .tmux.conf
        \,tmux.conf
        \ setfiletype tmux
  " Tab-separated (TSV) files
  autocmd BufNewFile,BufRead
        \ ?*.tsv
        \ setfiletype tsv
  " .wgetrc files
  autocmd BufNewFile,BufRead
        \ .wgetrc
        \,wgetrc
        \ setfiletype wget
  " XML files
  autocmd BufNewFile,BufRead
        \ ?*.xml
        \ setfiletype xml
  " Yacc files
  autocmd BufNewFile,BufRead
        \ ?*.y
        \,?*.yy
        \ setfiletype yacc

  " Load any extra rules in ftdetect directories
  runtime! ftdetect/*.vim

  " Generic text, config, and log files, if no type assigned yet
  autocmd BufNewFile,BufRead
        \ ?*.text
        \,?*.txt
        \,INSTALL
        \,README
        \,/etc/issue
        \,/etc/motd
        \ setfiletype text
  autocmd BufNewFile,BufRead
        \ ?*.cfg
        \,?*.conf
        \,?*.config
        \,/etc/*
        \ setfiletype config
  autocmd BufNewFile,BufRead
        \ */log/*
        \,?*.log
        \ setfiletype messages

  " Clumsy attempt at typing files in `sudo -e` if a filename hasn't already
  " been found; strip temporary extension and re-run
  autocmd BufNewFile,BufRead
        \ /var/tmp/?*.????????
        \ if !did_filetype()
        \|  call s:StripRepeat()
        \|endif

  " If we still don't have a filetype, run the scripts.vim file that performs
  " cleverer checks including looking at actual file contents--but only my
  " custom one; don't load the system one at all.
  autocmd BufNewFile,BufRead,StdinReadPost
        \ *
        \ if !did_filetype()
        \|  lua require'scripts'
        \|endif

  " If supported, on leaving insert mode, check whether the first line was
  " changed and looks like a shebang format, and if so, re-run filetype
  " detection
  if v:version > 700
    autocmd InsertLeave * call s:CheckShebang()
  endif

augroup END
