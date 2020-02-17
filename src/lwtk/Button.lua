local lwtk = require"lwtk"

local Super  = lwtk.Control
local Button = lwtk.newClass("lwtk.Button", Super)

function Button:new(initParams)
    Super.new(self, initParams)
end

return Button
