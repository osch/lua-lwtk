local lwtk = require("lwtk")

local Super         = lwtk.Compound(lwtk.Component)
local InnerCompound = lwtk.newClass("lwtk.InnerCompound", Super)

InnerCompound.addChild = lwtk.Compound.extra.addChild

return InnerCompound
