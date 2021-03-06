local internal = {}


setmetatable(internal, {
    __index = function(t,k)
        local m = require("lwtk.internal."..k)
        t[k] = m
        return m
    end
})

return internal
