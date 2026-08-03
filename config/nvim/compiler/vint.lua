local compiler = require("compiler_util")

if not compiler.claim("vimlint") then
  return
end

compiler.set("makeprg", compiler.prg("vint") .. " -- %:S")
compiler.set("errorformat", "%f:%l:%c: %m")
