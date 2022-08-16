local lwtk = require"lwtk"

local utf8         = lwtk.utf8
local Super        = lwtk.Component
local TextFragment = lwtk.newClass("lwtk.TextFragment", Super)

function TextFragment:new(initParams)
    self.tx = false
    self.ty = false
    self.label = ""
    Super.new(self, initParams)
end

function TextFragment:setText(text)
    if self.text ~= text then
        local a, b, c 
        if self.considerHotkey then
            a, b = string.match(text, "^([^&]*)&().*$")
        end
        if not a then
            a = ""
            b = ""
            c = text
            self.hotkey = nil
        else
            local nextCharPos = utf8.offset(text, 2, b)
            b = text:sub(b, nextCharPos - 1)
            c = text:sub(nextCharPos)
            local B = utf8.upper(b)
            self.hotkey = B
        end
        self.labelLeft  = a
        self.labelKey   = b
        self.labelRight = c
        self.label      = a..b..c
        self.text       = text
        self.textWidth  = false
        
        self:triggerRedraw()
    end
end

function TextFragment:setConsiderHotkey(flag)
    flag = flag and true or false
    if self.considerHotkey ~= flag then
        self.considerHotkey = flag
        local text = self.text
        if text then
            self.text = nil
            self:setText(self.text)
        end
    end
end

function TextFragment:setShowHotkey(flag)
    flag = flag and true or false
    if self.showHotKey ~= flag then
        self.showHotKey = flag
        if self.hotkey then
            self:triggerRedraw()
        end
    end
end

local Super_getFontInfo = Super.getFontInfo

local function getFontInfo(self)
    local textSize = self:getStyleParam("TextSize")
    local fontFamily = self:getStyleParam("FontFamily") or "sans-serif"
    if self.textSize ~= textSize or self.fontFamily ~= fontFamily then
        local fontInfo = Super_getFontInfo(self, fontFamily, "normal", "normal", textSize)
        self.fontInfo   = fontInfo
        self.textSize   = textSize
        self.fontFamily = fontFamily
        return fontInfo, true
    else
        return self.fontInfo, false
    end
end

TextFragment.getFontInfo = getFontInfo

function TextFragment:getTextMeasures()
    local fontInfo, changed = getFontInfo(self)
    local textWidth = self.textWidth
    if changed or not textWidth then
        textWidth = fontInfo:getTextWidth(self.label)
        self.textWidth = textWidth
    end
    return textWidth, fontInfo.height, fontInfo.ascent
end

function TextFragment:setTextPos(tx, ty)
    if self.tx ~= tx or self.ty ~= ty then
        self.tx = tx
        self.ty = ty
        self:triggerRedraw()
    end
end

function TextFragment:onDraw(ctx, ...)
    local label = self.label
    if label then
        local fontInfo = getFontInfo(self)
        fontInfo:selectInto(ctx)
        ctx:setColor(self:getStyleParam("TextColor"):toRGBA())
        local tx, ty = self.tx, self.ty
        if not tx or not ty then
            tx = 0
            ty = fontInfo.ascent
        end
        local offs = self:getStyleParam("TextOffset")
        if offs then
            tx = tx + offs
            ty = ty + offs
        end
        ctx:drawText(tx, ty, label) 
        if self.hotkey and self.showHotKey then
            local x1 = tx + fontInfo:getTextWidth(self.labelLeft)
            local x2 = x1 + fontInfo:getTextWidth(self.labelKey)
            local y1 = ty + math.floor(fontInfo.descent / 2 + 0.5) - 0.5
            ctx:setLineWidth(1)
            ctx:drawLine(x1, y1, x2, y1)
        end
    end
end

return TextFragment
