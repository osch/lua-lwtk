local format = string.format

local util = {}

local lua_version = _VERSION:match("[%d%.]*$")
local isOldLua = (#lua_version == 3 and lua_version < "5.3")

local getHashString

if not isOldLua or pcall(function() format("%p", {}) end) then -- >=lua5.3, luajit
    getHashString = function(self)
        return format("%p", self)
    end
else  -- lua5.1, lua5.2
    local getmt = debug.getmetatable
    local rawget, rawset, tostring, match = rawget, rawset, tostring, string.match
    getHashString = function(self)
        local mt = getmt(self)
        local tmp = rawget(mt, "__tostring")
        rawset(mt, "__tostring", nil)
        local hash = match(tostring(self), "([^ :]*)$")
        rawset(mt, "__tostring", tmp)
        return hash
    end
end

util.getHashString = getHashString

return util
