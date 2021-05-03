" Don't try to make these corrections if running 'compatible' or if the
" runtime files are too old
if &compatible || v:version < 700
  finish
endif

" Highlight TLSA and SSHFP records correctly
" <https://github.com/vim/vim/issues/220>
syn keyword zoneRRType contained TLSA SSHFP nextgroup=zoneRData skipwhite
