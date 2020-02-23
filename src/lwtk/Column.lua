local lwtk = require"lwtk"

local Super      = lwtk.Group
local Column     = lwtk.newClass("lwtk.Column", Super)

-------------------------------------------------------------------------------------------------

lwtk.internal.ColumnImpl.implementColumn(Column, false)

-------------------------------------------------------------------------------------------------

return Column
