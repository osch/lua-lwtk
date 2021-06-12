local lwtk = {}

lwtk._VERSION="scm"
lwtk.platform = require("lpugl").platform

setmetatable(lwtk, {
    __index = function(t,k)
        local m = require("lwtk."..k)
        t[k] = m
        return m
    end
})

return lwtk
