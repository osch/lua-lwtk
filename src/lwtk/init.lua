local lwtk = {}

lwtk.MOD_SHIFT =  1
lwtk.MOD_CTRL  =  2
lwtk.MOD_ALT   =  4
lwtk.MOD_SUPER =  8
lwtk.MOD_ALTGR = 16

setmetatable(lwtk, {
    __index = function(t,k)
        local m = require("lwtk."..k)
        t[k] = m
        return m
    end
})

return lwtk
