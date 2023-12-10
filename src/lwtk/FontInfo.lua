local lwtk = require"lwtk"

local FontInfo = lwtk.newClass("lwtk.FontInfo")

FontInfo:declare(
    "ascent",
    "descent",
    "family",
    "height",
    "layoutContext",
    "size",
    "slant",
    "weight"
)

function FontInfo:new(layoutContext, family, slant, weight, size)
    self.layoutContext = layoutContext
    self.family        = family
    self.slant         = slant
    self.weight        = weight
    self.size          = size
    layoutContext:selectFont(family, slant, weight, size)
    self.height, self.ascent = layoutContext:getFontHeightMeasures()
    self.descent = self.height - self.ascent
end

function FontInfo:getTextWidth(text)
    local ctx = self.layoutContext
    ctx:selectFont(self.family, self.slant, self.weight, self.size)
    return ctx:getTextWidth(text)
end

function FontInfo:selectInto(otherCtx)
    otherCtx:selectFont(self.family, self.slant, self.weight, self.size)
end

return FontInfo
