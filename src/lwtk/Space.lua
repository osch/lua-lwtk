local lwtk = require"lwtk"

local Super   = lwtk.Widget
local Space   = lwtk.newClass("lwtk.Space", Super)

function Space:getMeasures()
    return 0, 0, 0, 0, -2, -2
end

return Space
