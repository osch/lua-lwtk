local lwtk = require"lwtk"

local floor     = math.floor
local offset    = lwtk.utf8.offset
local codes     = lwtk.utf8.codes
local char      = lwtk.utf8.char
local codepoint = lwtk.utf8.codepoint

local FontInfo = lwtk.newClass("lwtk.FontInfo")

function FontInfo:new(layoutContext, family, slant, weight, size)
    self.layoutContext = layoutContext
    self.family        = family
    self.slant         = slant
    self.weight        = weight
    self.size          = size
    layoutContext:select_font_face(family, slant, weight)
    layoutContext:set_font_size(size)
    local ext          = layoutContext:font_extents()
    self.lineHeight    = ext.height
    self.height        = ext.ascent + ext.descent
    self.ascent        = ext.ascent
    self.descent       = ext.descent
end

function FontInfo:getTextWidth(text)
    local ctx = self.layoutContext
    ctx:select_font_face(self.family, self.slant, self.weight)
    ctx:set_font_size(self.size)
    return floor(ctx:text_extents(text).x_advance + 0.5)
end

function FontInfo:selectInto(ctx)
    ctx:select_font_face(self.family, self.slant, self.weight)
    ctx:set_font_size(self.size)
end

return FontInfo
