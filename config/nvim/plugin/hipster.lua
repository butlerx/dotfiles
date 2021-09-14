-- Define :Hipster command to dump in a paragraph of Hipster ipsum
vim.cmd [[
    command! -nargs=0 Hipster :lua require'hipster'.output()
]]
