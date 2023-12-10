--[[
    Modules for using *lwtk* with the [LÖVE](https://love2d.org/) 2D game engine.
]]
local internal = {}


setmetatable(internal, {
    __index = function(t,k)
        local m = require("lwtk.love."..k)
        t[k] = m
        return m
    end
})

return internal
