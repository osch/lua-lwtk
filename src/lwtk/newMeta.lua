local lwtk = require"lwtk"

local Meta             = lwtk.Meta
local fallbackToString = Meta.fallbackToString

--[[
    Creates new meta object. A meta object has lwtk.Meta as metatable
    and lwtk.type() evaluates to `"lwtk.Meta"`.
    
    See [lwtk.Meta Usage](../../Meta.md) for detailed documentation
    and usage examples.
]]
local function newMeta(name)
    local meta = {
        __name = name,
        __tostring = fallbackToString
    }
    return setmetatable(meta, Meta)
end

return newMeta
