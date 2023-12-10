local lwtk = require"lwtk"

local ltype = lwtk.type

--[[
    Creates new class object. A class object has lwtk.Class as metatable
    and lwtk.type() evaluates to `"lwtk.Class"`.
    
       * *className*  - string value
       * *superClass* - optional class object, if not given, lwtk.Object
                        is taken as superclass.
       * *...*        - optional further arguments that are reached over
                        to [lwtk.Object.newSubClass()](../lwtk/Object.md#.newSubClass).
    
    See [lwtk.Class Usage](../../Class.md) for detailed documentation
    and usage examples.
]]
local function newClass(className, superClass, ...)
    assert(type(className) == "string", "arg 1: exptected class name string")
    assert(not className:match("[()<>]"), "arg 1: invalid class name string")
    if superClass then
        assert(ltype(superClass) == "lwtk.Class", "arg 2 must be of type lwtk.Class")
    end
    local b = superClass or lwtk.Object
    local c = b:newSubClass(className, ...)
    return c
end

return newClass
