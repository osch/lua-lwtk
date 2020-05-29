local lwtk = require"lwtk"

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
    local ext          = layoutContext:font_extents()
    self.lineHeight    = ext.height
    self.height        = ext.ascent + ext.descent
    self.ascent        = ext.ascent
    self.descent       = ext.descent
    local widths       = {}
    self.widths        = widths
    layoutContext:select_font_face(family, slant, weight)
    layoutContext:set_font_size(size)
    for c = 32, 126 do
        widths[c] = layoutContext:text_extents(char(c)).x_advance
    end
end

function FontInfo:getCharWidth(c)
    local widths = self.widths
    local w = widths[c]
    if not w then
        local ctx = self.layoutContext
        ctx:select_font_face(self.family, self.slant, self.weight)
        ctx:set_font_size(self.size)
        local ext = ctx:text_extents(char(c))
        w = ext.x_advance
        widths[c] = w
    end
    return w
end

function FontInfo:getStringWidth(str, bytePos, charCount)
    local p = bytePos or 1
    local widths = self.widths
    local rslt = 0
    local fontSelected 
    local n = #str
    if not charCount or charCount > 0 then
        while p <= n do
            local c = codepoint(str, p)
            local w = widths[c]
            if not w then
                local ctx = self.layoutContext
                if not fontSelected then
                    ctx:select_font_face(self.family, self.slant, self.weight)
                    ctx:set_font_size(self.size)
                    fontSelected = true
                end
                local ext = ctx:text_extents(char(c))
                w = ext.x_advance
                widths[c] = w
            end
            rslt = rslt + w
            if charCount then   
                charCount = charCount - 1
                if charCount == 0 then 
                    break
                end
            end
            p = offset(str, 2, p)
        end
    end
    return rslt
end

function FontInfo:selectInto(ctx)
    ctx:select_font_face(self.family, self.slant, self.weight)
    ctx:set_font_size(self.size)
end

return FontInfo
