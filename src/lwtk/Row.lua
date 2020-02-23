local lwtk = require"lwtk"

local Super      = lwtk.Group
local Row        = lwtk.newClass("lwtk.Row", Super)

-------------------------------------------------------------------------------------------------

lwtk.internal.ColumnImpl.implementColumn(Row, true)

-------------------------------------------------------------------------------------------------

return Row
