local lwtk = require("lwtk")

--[[
    Holds a function with arguments that can
    be called.
]]
local Callback = lwtk.newMeta("lwtk.Callback")


function Callback:new(func, ...)
    local n = select("#", ...)
    for i = 1, n do
        self[i] = select(i, ...)
    end
    self.n    = n
    self.func = func
end

local function unpack(t, i, n, ...)
    if i <= n then
        return t[i], unpack(t, i + 1, n, ...)
    else
        return ...
    end
end

function Callback:__call(...)
    self.func(unpack(self, 1, self.n, ...))
end

return Callback
