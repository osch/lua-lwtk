local lwtk = {}

lwtk._VERSION="scm"

setmetatable(lwtk, {
    __index = function(t,k)
        local m = require("lwtk."..k)
        t[k] = m
        return m
    end
})

return lwtk
