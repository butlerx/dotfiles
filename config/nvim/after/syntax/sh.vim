" Don't try to make these corrections if running 'compatible' or if the
" runtime files are too old
if &compatible || v:version < 700
  finish
endif

" Remove g:is_posix if we resorted to it in order to get correct POSIX sh
" highlighting with older Vim runtime files
if exists('g:is_posix')
  unlet! g:is_posix g:is_kornshell
endif

" If we know we have another shell type, clear away the others completely, now
" that core syntax/sh.vim is done prodding /bin/sh to determine the system
" shell type (which I don't care about).
if exists('b:is_bash')
  unlet! b:is_sh b:is_posix b:is_kornshell
elseif exists('b:is_kornshell')
  unlet! b:is_sh b:is_posix
elseif exists('b:is_posix')
  unlet! b:is_sh
endif

" The syntax highlighter seems to flag '/baz' in '"${foo:-"$bar"/baz}"' as an
" error, which it isn't, at least in POSIX sh, Bash, and Ksh.
syntax clear shDerefWordError

" The syntax highlighter doesn't match parens for subshells for 'if' tests
" correctly if they're on separate lines. This happens enough that it's
" probably not worth keeping the error.
syntax clear shParenError

" The syntax highlighter flags this code with an error on the final square
" bracket: `case $foo in [![:ascii:]]) ;; esac`, but that's all legal. I'm not
" yet sure how to fix it, so will just turn the error group for now.
syntax clear shTestError

" Highlighting corrections specific to POSIX mode
if exists('b:is_posix')

  " Highlight some commands that are both defined by POSIX and builtin
  " commands in dash, as a rough but useable proxy for 'shell builtins'. This
  " list was mostly wrested from `man 1 dash`. Also include control structure
  " keywords like `break`, `continue`, and `return`.
  syntax clear shStatement
  syntax cluster shCommandSubList add=shStatement
  syntax cluster shCaseList add=shStatement
  syntax keyword shStatement
        \ alias
        \ bg
        \ break
        \ cd
        \ command
        \ continue
        \ echo
        \ eval
        \ exec
        \ exit
        \ export
        \ fc
        \ fg
        \ getopts
        \ hash
        \ kill
        \ printf
        \ pwd
        \ read
        \ readonly
        \ return
        \ set
        \ shift
        \ test
        \ times
        \ trap
        \ true
        \ type
        \ ulimit
        \ umask
        \ unalias
        \ unset
        \ wait

  " Core syntax/sh.vim puts IFS and other variables that affect shell function
  " in another color, but a subset of them actually apply to POSIX shell too
  " (and plain Bourne). These are selected by searching the POSIX manpages. I
  " added NLSPATH too, which wasn't in the original.
  syntax clear shShellVariables
  syntax cluster shCommandSubList add=shShellVariables
  syntax keyword shShellVariables
        \ CDPATH
        \ ENV
        \ FCEDIT
        \ HISTFILE
        \ HISTSIZE
        \ HISTTIMEFORMAT
        \ HOME
        \ IFS
        \ LANG
        \ LC_ALL
        \ LC_COLLATE
        \ LC_CTYPE
        \ LC_MESSAGES
        \ LC_NUMERIC
        \ LINENO
        \ MAIL
        \ MAILCHECK
        \ MAILPATH
        \ NLSPATH
        \ OLDPWD
        \ OPTARG
        \ OPTERR
        \ OPTIND
        \ PATH
        \ PS1
        \ PS2
        \ PS3
        \ PS4
        \ PWD

  " Core syntax/sh.vim thinks 'until' is a POSIX control structure keyword,
  " but it isn't. Reset shRepeat and rebuild it with just 'while'. I only
  " sort-of understand what this does, but it works.
  syntax clear shRepeat
  syntax region shRepeat
        \ matchgroup=shLoop
        \ start='\<while\_s' end='\<do\>'me=e-2
        \ contains=@shLoopList

  " Run some clustering that core syntax/sh.vim thinks doesn't apply to POSIX;
  " this fixes while loops so they can be within other blocks.
  syntax cluster shCaseList add=shRepeat
  syntax cluster shFunctionList add=shRepeat

  " ${foo%bar}, ${foo%%bar}, ${foo#bar}, and ${foo##bar} are all valid forms
  " of parameter expansion in POSIX, but sh.vim makes them conditional on
  " Bash or Korn shell. We reinstate them (slightly adapted) here.
  syntax match shDerefOp contained
        \ '##\|#\|%%\|%'
        \ nextgroup=@shDerefPatternList
  syntax match shDerefPattern contained
        \ '[^{}]\+'
        \ contains=shDeref,shDerefSimple,shDerefPattern,shDerefString,shCommandSub,shDerefEscape
        \ nextgroup=shDerefPattern
  syntax region shDerefPattern contained
        \ start='{' end='}'
        \ contains=shDeref,shDerefSimple,shDerefString,shCommandSub
        \ nextgroup=shDerefPattern

endif

" Some corrections for highlighting specific to the Bash mode
if exists('b:is_bash')

  " I don't like bashAdminStatement; these are not keywords, they're just
  " strings for init scripts.
  syntax clear bashAdminStatement

  " Reduce bashStatement down to just builtins; highlighting 'grep' is not
  " very useful. This list was taken from `compgen -A helptopic` on Bash
  " 4.4.5.
  syntax clear bashStatement
  syntax keyword bashStatement
        \ .
        \ :
        \ alias
        \ bg
        \ bind
        \ break
        \ builtin
        \ caller
        \ cd
        \ command
        \ compgen
        \ complete
        \ compopt
        \ continue
        \ coproc
        \ dirs
        \ disown
        \ echo
        \ enable
        \ eval
        \ exec
        \ exit
        \ false
        \ fc
        \ fg
        \ function
        \ getopts
        \ hash
        \ help
        \ history
        \ jobs
        \ kill
        \ let
        \ logout
        \ mapfile
        \ popd
        \ printf
        \ pushd
        \ pwd
        \ read
        \ readarray
        \ readonly
        \ return
        \ select
        \ set
        \ shift
        \ shopt
        \ source
        \ suspend
        \ test
        \ time
        \ times
        \ trap
        \ true
        \ type
        \ ulimit
        \ umask
        \ unalias
        \ until
        \ variables
        \ wait
endif
