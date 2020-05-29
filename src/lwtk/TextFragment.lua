local lwtk = require"lwtk"

local Super        = lwtk.Widget
local TextFragment = lwtk.newClass("lwtk.TextFragment", Super, lwtk.Styleable.ADOPT_PARENT_STYLE)

function TextFragment:new(initParams)
    Super.new(self, initParams)
end

function TextFragment:setText(text)
    self.text = text
    self.textWidth = false
    self.textHeight = false
end

local Super_getFontInfo = Super.getFontInfo

local function getFontInfo(self)
    local textSize = self:getStyleParam("TextSize")
    local fontFamily = self:getStyleParam("FontFamily") or "sans-serif"
    if self.textSize ~= textSize then
        local fontInfo = Super_getFontInfo(self, fontFamily, "normal", "normal", textSize)
        self.fontInfo = fontInfo
        self.textSize = textSize
        return fontInfo, true
    else
        return self.fontInfo, false
    end
end

TextFragment.getFontInfo = getFontInfo

function TextFragment:getMeasures()
    local text = self.text
    if text then
        local w, h = self.textWidth, self.textHeight
        if not w or not h then
            local fontInfo = getFontInfo(self)
            local ctx = self:getLayoutContext()
            fontInfo:selectInto(ctx)
            local ext = ctx:text_extents(text)
            w, h = ext.width, ext.height
        end
        return w, h
    else
        return 0, 0
    end
end


function TextFragment:onDraw(ctx)
    local text = self.text
    if text then
        local fontInfo = getFontInfo(self)
        fontInfo:selectInto(ctx)
        ctx:set_source_rgba(self:getStyleParam("TextColor"):toRGBA())
        ctx:move_to(0, fontInfo.ascent)
        ctx:show_text(text)
    end
end

return TextFragment
