local lwtk = require"lwtk"

local Super      = lwtk.Button
local PushButton = lwtk.newClass("lwtk.PushButton", Super)

function PushButton:new(initParams)
    Super.new(self, initParams)
end

return PushButton
