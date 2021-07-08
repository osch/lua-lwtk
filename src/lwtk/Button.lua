local lwtk = require"lwtk"

local Super             = lwtk.HotkeyListener(lwtk.Control(lwtk.Compound(lwtk.Widget)))
local Button            = lwtk.newClass("lwtk.Button", Super)

return Button
