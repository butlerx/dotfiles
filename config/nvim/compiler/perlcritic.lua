local compiler = require("compiler_util")

if not compiler.claim("perlcritic") then
  return
end

compiler.set("makeprg", compiler.prg("perlcritic") .. " --verbose 1 -- %:S")
compiler.set("errorformat", "%f:%l:%c:%m")
