local lwtk = require("lwtk")

local pcall = pcall

local WeakKeysTable = lwtk.WeakKeysTable

local function tryget2(t, k)
    return t[k]
end

local function tryget(t, k)
    local ok, rslt = pcall(tryget2, t, k)
    if ok then
        return rslt
    end
end

--[[
    Discard object that should no longer be used.
    
    This function could be useful under Lua 5.1 which does not have ephemeron tables.
]]
local function discard(arg)
    if type(arg) == "table" then
        local mt = getmetatable(arg)
        if mt then
            local d = tryget(mt, "discard")
            if d then
                return d(arg)
            end
        end    
    end
    WeakKeysTable.discard(arg)
    return arg
end

return discard
