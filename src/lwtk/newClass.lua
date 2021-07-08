local lwtk = require"lwtk"
local type  = lwtk.type

local function newClass(className, baseClass, ...)
    if baseClass then
        assert(type(baseClass) == "lwtk.Class", "arg 2 must be of type lwtk.Class")
    end
    local b = baseClass or lwtk.Object
    local c = b.newSubClass(className, b, ...)
    return c
end

return newClass
