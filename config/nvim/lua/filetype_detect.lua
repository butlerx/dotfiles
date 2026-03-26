local function strip_one_extension(path)
  return path:gsub("%.[^./]+$", "")
end

local function strip_repeat(path, bufnr)
  local stripped = path

  if stripped:match("^#+.+#+$") then
    stripped = stripped:gsub("^#+", ""):gsub("#+$", "")
  elseif stripped:match("~$") then
    stripped = stripped:gsub("~$", "")
  else
    stripped = strip_one_extension(stripped)
  end

  if stripped == "" or stripped == path then
    return
  end

  return vim.filetype.match({ filename = stripped, buf = bufnr })
end

local function set_bash(_, bufnr)
  vim.b[bufnr].is_bash = 1
  return "sh"
end

local function set_ksh(_, bufnr)
  vim.b[bufnr].is_kornshell = 1
  return "sh"
end

local function set_posix(_, bufnr)
  vim.b[bufnr].is_posix = 1
  return "sh"
end

local function run_scripts_fallback(_, bufnr)
  if vim.bo[bufnr].filetype ~= "" then
    return
  end

  package.loaded.scripts = nil
  pcall(require, "scripts")

  if vim.bo[bufnr].filetype ~= "" then
    return vim.bo[bufnr].filetype
  end
end

local extensions = {
  awk = "awk",
  bash = set_bash,
  c = "c",
  ["c++"] = "cpp",
  cfg = { "config", { priority = -1 } },
  conf = { "config", { priority = -1 } },
  config = { "config", { priority = -1 } },
  cpp = "cpp",
  cxx = "cpp",
  css = "css",
  csv = "csv",
  diff = "diff",
  dot = "dot",
  ejs = "javascript",
  epp = "embeddedpuppet",
  fs = "forth",
  ft = "forth",
  h = "c",
  hh = "cpp",
  htm = "html",
  html = "html",
  ini = "dosini",
  jav = "java",
  java = "java",
  js = "javascript",
  json = "json",
  ksh = set_ksh,
  l = "lex",
  lex = "lex",
  log = { "messages", { priority = -1 } },
  lua = "lua",
  m4 = "m4",
  markdown = "markdown",
  md = "markdown",
  mjs = "javascript",
  nu = "nu",
  p6 = "perl6",
  patch = "diff",
  php = "php",
  pl = "perl",
  pl6 = "perl6",
  pm = "perl",
  pm6 = "perl6",
  pod = "pod",
  pod6 = "pod6",
  pp = "puppet",
  py = "python",
  rb = "ruby",
  rej = "diff",
  rem = "remind",
  remind = "remind",
  roff = "nroff",
  s = "asm",
  sed = "sed",
  sh = set_posix,
  sql = "sql",
  tcl = "tcl",
  text = { "text", { priority = -1 } },
  ti = "terminfo",
  tsv = "tsv",
  vim = "vim",
  xht = "xhtml",
  xhtml = "xhtml",
  xml = "xml",
  xs = "xs",
  y = "yacc",
  yaml = "yaml",
  yml = "yaml",
  yy = "yacc",
  zsh = "zsh",
}

local filenames = {
  [".Xresources"] = "xdefaults",
  [".bash_aliases"] = set_bash,
  [".bash_completion"] = set_bash,
  [".bash_logout"] = set_bash,
  [".bash_profile"] = set_bash,
  [".bashrc"] = set_bash,
  ["bash_aliases"] = set_bash,
  ["bash_completion"] = set_bash,
  ["bash_logout"] = set_bash,
  ["bash_profile"] = set_bash,
  ["bashrc"] = set_bash,
  [".gdbinit"] = "gdb",
  [".gitconfig"] = "gitconfig",
  [".gitmodules"] = "gitconfig",
  [".inputrc"] = "readline",
  [".kshrc"] = set_ksh,
  [".muttrc"] = "muttrc",
  [".netrc"] = "netrc",
  [".profile"] = set_posix,
  [".reminders"] = "remind",
  [".shinit"] = set_posix,
  [".shrc"] = set_posix,
  [".tidyrc"] = "tidy",
  [".tmux.conf"] = "tmux",
  [".viminfo"] = "viminfo",
  [".wgetrc"] = "wget",
  [".xinitrc"] = set_posix,
  [".zprofile"] = "zsh",
  [".zshrc"] = "zsh",
  [".htaccess"] = "apache",
  ["COMMIT_EDITMSG"] = "gitcommit",
  ["INSTALL"] = { "text", { priority = -1 } },
  ["Makefile"] = "make",
  ["Makefile.PL"] = "perl",
  ["MERGE_MSG"] = "gitcommit",
  ["Muttrc"] = "muttrc",
  ["Puppetfile"] = "ruby",
  ["README"] = { "text", { priority = -1 } },
  ["TAG_EDITMSG"] = "gitcommit",
  ["Xresources"] = "xdefaults",
  ["_exrc"] = "vim",
  ["_gvimrc"] = "vim",
  ["_vimrc"] = "vim",
  ["aliases"] = "mailaliases",
  ["configure"] = set_posix,
  ["crontab"] = "crontab",
  ["exrc"] = "vim",
  ["fstab"] = "fstab",
  ["git-rebase-todo"] = "gitrebase",
  ["gitconfig"] = "gitconfig",
  ["gvimrc"] = "vim",
  ["inittab"] = "inittab",
  ["kshrc"] = set_ksh,
  ["makefile"] = "make",
  ["named.conf"] = "named",
  ["named.root"] = "bindzone",
  ["netrc"] = "netrc",
  ["profile"] = set_posix,
  ["rndc.conf"] = "named",
  ["rndc.key"] = "named",
  ["robots.txt"] = "robots",
  ["shinit"] = set_posix,
  ["shrc"] = set_posix,
  ["ssh_config"] = "sshconfig",
  ["sshd_config"] = "sshdconfig",
  ["sudoers"] = "sudoers",
  ["sudoers.tmp"] = "sudoers",
  ["tidyrc"] = "tidy",
  ["tmux.conf"] = "tmux",
  ["vimrc"] = "vim",
  ["wgetrc"] = "wget",
  ["xinitrc"] = set_posix,
  ["zprofile"] = "zsh",
  ["zshrc"] = "zsh",
  ["/etc/group"] = "group",
  ["/etc/group-"] = "group",
  ["/etc/group.edit"] = "group",
  ["/etc/gshadow"] = "group",
  ["/etc/gshadow-"] = "group",
  ["/etc/gshadow.edit"] = "group",
  ["/etc/issue"] = { "text", { priority = -1 } },
  ["/etc/motd"] = { "text", { priority = -1 } },
  ["/etc/passwd"] = "passwd",
  ["/etc/passwd-"] = "passwd",
  ["/etc/passwd.edit"] = "passwd",
  ["/etc/services"] = "services",
  ["/etc/shadow"] = "passwd",
  ["/etc/shadow-"] = "passwd",
  ["/etc/shadow.edit"] = "passwd",
}

local patterns = {
  ["^#.+#$"] = { strip_repeat, { priority = -1 } },
  [".*/#.+#$"] = { strip_repeat, { priority = -1 } },
  [".*~$"] = { strip_repeat, { priority = -1 } },
  [".*%.bak$"] = { strip_repeat, { priority = -1 } },
  [".*%.dpkg%-bak$"] = { strip_repeat, { priority = -1 } },
  [".*%.dpkg%-dist$"] = { strip_repeat, { priority = -1 } },
  [".*%.dpkg%-new$"] = { strip_repeat, { priority = -1 } },
  [".*%.dpkg%-old$"] = { strip_repeat, { priority = -1 } },
  [".*%.example$"] = { strip_repeat, { priority = -1 } },
  [".*%.in$"] = { strip_repeat, { priority = -1 } },
  [".*%.new$"] = { strip_repeat, { priority = -1 } },
  [".*%.old$"] = { strip_repeat, { priority = -1 } },
  [".*%.orig$"] = { strip_repeat, { priority = -1 } },
  [".*%.sample$"] = { strip_repeat, { priority = -1 } },
  [".*%.test$"] = { strip_repeat, { priority = -1 } },
  [".*/%.Xresources%.d/.*"] = "xdefaults",
  [".*/%.ssh/config$"] = "sshconfig",
  [".*/apache.*/.*%.conf$"] = "apache",
  [".*/bind/db%..+$"] = "bindzone",
  [".*/cron%.d/.*"] = "crontab",
  [".*/etc/default/.*"] = set_posix,
  [".*/man[1-9].*/.*%.[1-9].*$"] = "nroff",
  [".*/namedb/db%..+$"] = "bindzone",
  [".*/t/.*%.t$"] = "perl",
  [".*/xt/.*%.t$"] = "perl",
  [".*/vim%-.*/doc/.*%.txt$"] = "help",
  [".*/%.vim/doc/.*%.txt$"] = "help",
  [".*/etc/Muttrc%.d/.*"] = "muttrc",
  [".*/etc/nanorc$"] = "nanorc",
  [".*/dev/shm/pass%..*/.*%.txt$"] = "password",
  [".*/tmp/pass%..*/.*%.txt$"] = "password",
  [".*/log/.*"] = { "messages", { priority = -1 } },
  [".*/systemd/.+%..+$"] = "systemd",
  [".*/gnupg/options$"] = "gpg",
  [".*/gnupg/gpg%.conf$"] = "gpg",
  [".*%.exrc$"] = "vim",
  [".*%.git/config$"] = "gitconfig",
  [".*%.gktrc.*$"] = "gtkrc",
  [".*%.gvimrc$"] = "vim",
  [".*%.kshrc$"] = set_ksh,
  [".*%.msg$"] = "mail",
  [".*%.nanorc$"] = "nanorc",
  [".*%.text$"] = { "text", { priority = -1 } },
  [".*%.txt$"] = { "text", { priority = -1 } },
  [".*%.vimrc$"] = "vim",
  [".*%.[1-9]$"] = "nroff",
  [".*bash%-fc%..+$"] = set_bash,
  [".*crontab%..+$"] = "crontab",
  [".*gktrc.*$"] = "gtkrc",
  [".*mutt%-%d+%-%d+%-%d+$"] = "mail",
  [".*svn%-commit.*%.tmp$"] = "svn",
  [".*/%.muttrc%.d/.*%.rc$"] = "muttrc",
  ["/etc/.*"] = { "config", { priority = -1 } },
  ["/var/tmp/.+%........$"] = {
    function(path, bufnr)
      if vim.bo[bufnr].filetype ~= "" then
        return
      end

      local stripped = strip_one_extension(path)
      if stripped == "" or stripped == path then
        return
      end

      return vim.filetype.match({ filename = stripped, buf = bufnr })
    end,
    { priority = -2 },
  },
  [".*"] = { run_scripts_fallback, { priority = -math.huge } },
}

if vim.env.HOME and vim.env.HOME ~= "" then
  patterns[vim.pesc(vim.env.HOME) .. "/%.vim/doc/.*%.txt$"] = "help"
end

if vim.env.VIMRUNTIME and vim.env.VIMRUNTIME ~= "" then
  patterns[vim.pesc(vim.env.VIMRUNTIME) .. "/doc/.*%.txt$"] = "help"
end

if vim.env.TMPDIR and vim.env.TMPDIR ~= "" then
  patterns[vim.pesc(vim.env.TMPDIR) .. "/pass%..*/.*%.txt$"] = "password"
end

if vim.env.ENV and vim.env.ENV ~= "" then
  filenames[vim.env.ENV] = set_posix
end

vim.filetype.add({
  extension = extensions,
  filename = filenames,
  pattern = patterns,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'[") == 1 and vim.fn.getline(1):match("^#!") then
      vim.cmd("doautocmd filetypedetect BufRead")
    end
  end,
})

vim.api.nvim_create_autocmd("StdinReadPost", {
  pattern = "*",
  callback = function(args)
    run_scripts_fallback(nil, args.buf)
  end,
})
