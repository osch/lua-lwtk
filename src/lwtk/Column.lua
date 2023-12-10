local lwtk = require"lwtk"

local Super      = lwtk.Group
local Column     = lwtk.newClass("lwtk.Column", Super)

-------------------------------------------------------------------------------------------------

local impl = lwtk.internal.ColumnImpl.implementColumn(false)

--[[
    @function(self)
]]
Column.implement.getMeasures = impl.getMeasures

--[[
    @function(self, width, height, isLayoutTransition)
]]
Column.implement.onLayout = impl.onLayout

-------------------------------------------------------------------------------------------------

return Column
