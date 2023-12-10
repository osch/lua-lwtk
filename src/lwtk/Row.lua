local lwtk = require"lwtk"

local Super      = lwtk.Group
local Row        = lwtk.newClass("lwtk.Row", Super)

-------------------------------------------------------------------------------------------------

local impl = lwtk.internal.ColumnImpl.implementColumn(true)

--[[
    @function(self)
]]
Row.implement.getMeasures = impl.getMeasures

--[[
    @function(self, width, height, isLayoutTransition)
]]
Row.implement.onLayout = impl.onLayout

-------------------------------------------------------------------------------------------------

return Row
