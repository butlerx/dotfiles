-- Don't try to make these corrections if running 'compatible' or if the
-- runtime files are too old

-- The highlighting for errors in syslog/messages files is more often annoying
-- than useful, so just turn it off.
_G["vim"].cmd [[
syntax clear messagesError
]]
