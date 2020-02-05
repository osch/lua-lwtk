local lwtk = require"lwtk"

local Super  = lwtk.Widget
local Box    = lwtk.newClass("lwtk.Box", Super)

function Box:new(initParams)
    Super.new(self, initParams)
end

return Box
