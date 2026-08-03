local compiler = require("compiler_util")

if not compiler.claim("shellcheck") then
  return
end

-- Tell shellcheck which dialect to apply, from the buffer's shell subtype
local dialect = require("autoload.sh").dialect(0)

compiler.set("makeprg", compiler.prg("shellcheck") .. " -e SC1090 -f gcc -s " .. dialect .. " -- %:S")
compiler.set("errorformat", "%f:%l:%c: %m [SC%n]")
