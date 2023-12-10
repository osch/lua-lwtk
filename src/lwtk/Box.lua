local lwtk = require"lwtk"

local Super   = lwtk.Control(lwtk.Group)
local Box     = lwtk.newClass("lwtk.Box", Super)

Box.implement.getMeasures = lwtk.LayoutFrame.extra.getMeasures

return Box
