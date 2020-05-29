local lwtk = require"lwtk"

local fillRect     = lwtk.draw.fillRect
local Color        = lwtk.Color
local Super        = lwtk.Widget
local TextCursor   = lwtk.newClass("lwtk.TextCursor", Super, lwtk.Styleable.ADOPT_PARENT_STYLE)

function TextCursor:onDraw(ctx)
    local color = self:getStyleParam("CursorColor") or Color("000000")
    fillRect(ctx, color, 0, 0, self.w, self.h)
end

return TextCursor