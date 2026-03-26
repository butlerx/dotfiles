-- Don't try to make these corrections if running 'compatible' or if the
-- runtime files are too old

-- If my commit subject is too long, highlight it as an error.
_G["vim"].cmd [[
highlight link gitCommitOverflow Error
]]
