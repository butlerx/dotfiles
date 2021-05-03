" Try to determine filetype by examining actual file contents; read as little
" as possible, and try to keep things simple and specific to what I typically
" work on, and will expect to be syntax-highlighted.

" Read first line
let s:line = getline(1)

" If it's not a shebang, we're done
if s:line !~# '^#!'
  finish
endif

" AWK
if s:line =~# '\<[gm]\=awk\>'
  setfiletype awk

" Perl 5
elseif s:line =~# '\<perl5\=\>'
  setfiletype perl

" Perl 6
elseif s:line =~# '\<perl6\>'
  setfiletype perl6

" PHP
elseif s:line =~# '\<php\>'
  setfiletype php

" Python
elseif s:line =~# '\<python[23]\=\>'
  setfiletype python

" Ruby
elseif s:line =~# '\<ruby[23]\=\>'
  setfiletype ruby

" sed
elseif s:line =~# '\<sed\>'
  setfiletype sed

" Bash
elseif s:line =~# '\<bash\>'
  let b:is_bash = 1
  setfiletype sh

" Korn shell
elseif s:line =~# '\<\%(\ksh\|ksh93\|mksh\|pdksh\)\>'
  let b:is_kornshell = 1
  setfiletype sh

" POSIX/Bourne shell
elseif s:line =~# '\<sh\>'
  let b:is_posix = 1
  setfiletype sh

" TCL
elseif s:line =~# '\<\%(tcl\|wish\)\>'
  setfiletype tcl

endif
