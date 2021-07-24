local lwtk = require("lwtk")

local Super         = lwtk.Compound(lwtk.Component)
local InnerCompound = lwtk.newClass("lwtk.InnerCompound", Super)

return InnerCompound
