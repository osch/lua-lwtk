local lwtk = require"lwtk"

local floor      = math.floor
local Super      = lwtk.Group
local Row        = lwtk.newClass("lwtk.Row", Super)

local setOuterMargins = lwtk.layout.setOuterMargins
local getOuterMargins = lwtk.layout.getOuterMargins

lwtk.Column._implementColumn(Row, true)

return Row
