local lwtk = require"lwtk"

local Color        = lwtk.Color
local Super        = lwtk.Component
local TextCursor   = lwtk.newClass("lwtk.TextCursor", Super)

function TextCursor.implement:onDraw(ctx)
    local color = self:getStyleParam("CursorColor") or Color("000000")
    ctx:fillRect(color, 0, 0, self.w, self.h)
end

return TextCursor