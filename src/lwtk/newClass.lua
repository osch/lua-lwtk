local lwtk = require"lwtk"

local function newClass(className, baseClass)
    local b = baseClass or lwtk.Object
    local c = b.newClass(className, b)
    return c
end

return newClass
