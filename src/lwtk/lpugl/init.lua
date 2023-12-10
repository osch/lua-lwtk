--[[
    Modules for using *lwtk* on top of [LPugl](https://github.com/osch/lua-lpugl#lpugl),
    a minimal Lua-API for building GUIs for Linux, Windows or macOS.
]]
local internal = {}


setmetatable(internal, {
    __index = function(t,k)
        local m = require("lwtk.lpugl."..k)
        t[k] = m
        return m
    end
})

return internal
