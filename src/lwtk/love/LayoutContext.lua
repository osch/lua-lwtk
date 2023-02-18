local lwtk = require"lwtk"

local floor = math.floor

local LayoutContext = lwtk.newClass("lwtk.love.LayoutContext")

function LayoutContext:new()
    love.graphics.reset()
    self.fonts = {}
end

function LayoutContext:_reset()
    love.graphics.reset()
end

function LayoutContext:selectFont(family, slant, weight, size)
    local familyFonts = self.fonts[family]
    if not familyFonts then
        familyFonts = {}
        self.fonts[family] = familyFonts
    end
    local font = familyFonts[size]
    if not font then
        font = love.graphics.newFont(size)
        familyFonts[size] = font
    end
    love.graphics.setFont(font)
    local ascent, descent = font:getAscent(), -font:getDescent()
    self.font       = font
    self.fontHeight = ascent + descent
    self.fontAscent = ascent
end

function LayoutContext:getFontHeightMeasures()
    return self.fontHeight, self.fontAscent
end

function LayoutContext:getTextWidth(text)
    text = love.graphics.newText(self.font, text)
    return floor(text:getWidth() + 0.5)
end

function LayoutContext:getTextMeasures(text)
    text = love.graphics.newText(self.font, text)
    return text:getWidth(), text:getHeight()
end

return LayoutContext
