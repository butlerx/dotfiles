local utils = {}
local api = vim.api

utils.map = function(key)
    -- get the extra options
    local opts = { noremap = true, silent = true }
    for i, v in pairs(key) do
        if type(i) == "string" then
            opts[i] = v
        end
    end

    -- basic support for buffer-scoped keybindings
    local buffer = opts.buffer
    opts.buffer = nil

    if buffer then
        api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
    else
        api.nvim_set_keymap(key[1], key[2], key[3], opts)
    end
end

utils.create_augroups = function(definitions)
    for group_name, definition in pairs(definitions) do
        api.nvim_command("augroup " .. group_name)
        api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            -- if type(def) == 'table' and type(def[#def]) == 'function' then
            -- 	def[#def] = lua_callback(def[#def])
            -- end
            local command = table.concat(vim.iter({ "autocmd", def }):flatten():totable(), " ")
            api.nvim_command(command)
        end
        api.nvim_command("augroup END")
    end
end

return utils
