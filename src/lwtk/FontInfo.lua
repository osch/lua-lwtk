local lwtk = require"lwtk"

local floor     = math.floor

local FontInfo = lwtk.newClass("lwtk.FontInfo")

local adjustFamilyName

if lwtk.platform == "WIN" then
    function adjustFamilyName(family)
        if family == "monospace" then
            return "Courier New"
        else
            return family
        end
    end
else
    function adjustFamilyName(family)
        return family
    end
end

function FontInfo:new(layoutContext, family, slant, weight, size)
    self.layoutContext = layoutContext
    self.family        = family
    self.slant         = slant
    self.weight        = weight
    self.size          = size
    layoutContext:select_font_face(adjustFamilyName(family), slant, weight)
    layoutContext:set_font_size(size)
    local ext          = layoutContext:font_extents()
    self.lineHeight    = ext.height
    self.height        = ext.ascent + ext.descent
    self.ascent        = ext.ascent
    self.descent       = ext.descent
end

function FontInfo:getTextWidth(text)
    local ctx = self.layoutContext
    ctx:select_font_face(adjustFamilyName(self.family), self.slant, self.weight)
    ctx:set_font_size(self.size)
    return floor(ctx:text_extents(text).x_advance + 0.5)
end

function FontInfo:selectInto(ctx)
    ctx:select_font_face(adjustFamilyName(self.family), self.slant, self.weight)
    ctx:set_font_size(self.size)
end

return FontInfo
