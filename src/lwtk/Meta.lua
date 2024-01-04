local lwtk = require("lwtk")

--[[
    Metatable for objects created by lwtk.newMeta().

    See [lwtk,Meta Usage](../../Meta.md) for detailed documentation
    and usage examples.
]]
local Meta = {} 

Meta.__name = "lwtk.Meta"
    
function Meta:__tostring()
    if self.__name then
        return string.format("lwtk.Meta<%s>", self.__name)
    else
        return "lwtk.Meta"
    end
end

local lua_version = _VERSION:match("[%d%.]*$")
local isOldLua = (#lua_version == 3 and lua_version < "5.3")

if isOldLua then
    local getHashString = lwtk.util.getHashString
    local format, getmt, rawget = string.format, debug.getmetatable, rawget
    Meta.fallbackToString = function(self)
        local mt   = getmt(self)
        local hash = getHashString(self)
        return format("%s: %s", rawget(mt, "__name"), hash)
    end
end

function Meta:__call(...)
    local obj = {}
    setmetatable(obj, self)
    local new = self.new
    if new then new(obj, ...) end
    return obj
end

return Meta
