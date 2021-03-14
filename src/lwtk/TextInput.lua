local lwtk = require"lwtk"

local floor         = math.floor
local Border        = lwtk.Border
local Focusable     = lwtk.Focusable
local Compound      = lwtk.Compound
local TextFragment  = lwtk.TextFragment
local TextCursor    = lwtk.TextCursor
local addChild      = Compound.addChild

local Super      = lwtk.Control
local TextInput  = lwtk.newClass("lwtk.TextInput", Super)

TextInput:implementFrom(Focusable)
TextInput:implementFrom(Compound)

TextInput.onDraw   = Border.onDraw

function TextInput:new(initParams)
    local inner = addChild(self, Compound())
    self.inner        = inner
    self.cursor       = addChild(inner, TextCursor())
    self.textFragment = addChild(inner, TextFragment())
    self.cursorPos    = 1
    Super.new(self, initParams)
end

function TextInput:setText(text)
    self.text = text
    self.textFragment:setText(text)
end

function TextInput:getMeasures()
    local width  = (self:getStyleParam("Width") or 0)
    local height = (self:getStyleParam("Height") or 0)
    local fontInfo = self.textFragment:getFontInfo()
    local minColumns  = (self:getStyleParam("MinColumns") or  5)
    local bestColumns = (self:getStyleParam("Columns")    or 30)
    local maxColumns  = (self:getStyleParam("MaxColumns") or -1)
    
    local addW =   (self:getStyleParam("LeftPadding") or 0)
                 + (self:getStyleParam("RightPadding") or 0)

    local xW    = fontInfo:getStringWidth("x")
    local minW  = minColumns  * xW + addW
    local bestW = bestColumns * xW + addW
    local maxW  = maxColumns > 0 and (maxColumns * xW + addW) or -1

    return minW, height, bestW, height, maxW, height
end

local function innerLayout(self)
    local inner              = self.inner
    local textFragment       = self.textFragment
    local iw, ih             = inner.w, inner.h
    local fontInfo, reloaded = textFragment:getFontInfo()
    local fh = fontInfo.height
    local dy = floor((ih - fh)/2)
    textFragment:setFrame(0, 
                          dy,
                          iw, fh)
    local cx = fontInfo:getStringWidth(self.text, 1, self.cursorPos - 1)
    self.cursor:setFrame(cx, dy, self:getStyleParam("CursorWidth") or 1, fh)
end

function TextInput:onLayout(width, height)
    Border.onLayout(self, width, height)
    innerLayout(self)
end

function TextInput:onFocusIn()
    self:setState("focused", true)
end
function TextInput:onFocusOut()
    self:setState("focused", false)
end

function TextInput:onActionCursorRight()
    local p = self.cursorPos
    if p <= #self.text then
        self.cursorPos = p + 1
        innerLayout(self)
    end
    return true
end
function TextInput:onActionCursorLeft()
    local p = self.cursorPos
    if p > 1 then 
        self.cursorPos = p - 1
        innerLayout(self)
    end
    return true
end

return TextInput
