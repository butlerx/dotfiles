-- Don't try to make these corrections if running 'compatible' or if the
-- runtime files are too old

-- Highlight TLSA and SSHFP records correctly
-- <https://github.com/vim/vim/issues/220>
_G["vim"].cmd [[
syn keyword zoneRRType contained TLSA SSHFP nextgroup=zoneRData skipwhite
]]
