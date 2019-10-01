" Revert settings that Debian might have touched
if $VIM !=# '/usr/share/vim' || !filereadable('/etc/debian_version')
  finish
endif

" Set options back to appropriate defaults
set history&
set suffixes&
if has('cmdline_info')
  set ruler&
endif
if has('printoptions')
  set printoptions&
endif

" Restore terminal settings to reflect terminfo
set t_Co& t_Sf& t_Sb&
set t_Co=256

" Remove addons directories from 'runtimepath' if present
set runtimepath-=/var/lib/vim/addons
set runtimepath-=/var/lib/vim/addons/after
