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
    if pcall(function() string.format("%p", {}) end) then

        Meta.fallbackToString = function(self)
            local mt = getmetatable(self)
            return string.format("%s: %p", mt.__name, self) -- luajit
        end
    else
        Meta.fallbackToString = function(self)
            local mt = debug.getmetatable(self)
            local tmp = rawget(mt, "__tostring")
            rawset(mt, "__tostring", nil)
            local hash = tostring(self):match("([^ :]*)$")
            rawset(mt, "__tostring", tmp)
            return string.format("%s: %s", rawget(mt, "__name"), hash) -- lua5.1, lua5.2
        end
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
