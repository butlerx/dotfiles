-- Try to determine filetype by examining actual file contents; read as little
-- as possible, and try to keep things simple and specific to what I typically
-- work on, and will expect to be syntax-highlighted.
-- Read first line
local line = vim.fn.getline(1)
local filetype = vim.opt.filetype

-- If it's not a shebang, we're done

if not line.starts("^#!") then
    return
end

if line.find("<[gm]=awk>") then
    -- AWK
    filetype = "awk"
elseif line.find("<perl5=>") then
    -- Perl 5
    filetype = "perl"
elseif line.find("<perl6>") then
    -- Perl 6
    filetype = "perl6"
elseif line.find("<php>") then
    -- PHP
    filetype = "php"
elseif line.find("<python[23]=>") then
    -- Python
    filetype = "python"
elseif line.find("<ruby[23]=>") then
    -- Ruby
    filetype = "ruby"
elseif line.find("<sed>") then
    -- sed
    filetype = "sed"
elseif line.find("<bash>") then
    -- Bash
    vim.b.is_bash = true
    filetype = "sh"
elseif line.find("<%(ksh|ksh93|mksh|pdksh)>") then
    -- Korn shell
    vim.b.is_kornshell = true
    filetype = "sh"
elseif line.find("<sh>") then
    -- POSIX/Bourne shell
    vim.b.is_posix = 1
    filetype = "sh"
elseif line.find("<%(tcl|wish)>") then
    -- TCL
    filetype = "tcl"
end
