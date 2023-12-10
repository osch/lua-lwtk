local lwtk = require"lwtk"

local getFocusHandler = lwtk.get.focusHandler
local TextFragment    = lwtk.TextFragment

local Super           = lwtk.Button
local TextLabel       = lwtk.newClass("lwtk.TextLabel", Super)

TextLabel:declare(
    "textFragment",
    "text",
    "input"
)

function TextLabel.override:new(initParams)
    Super.new(self)
    self.textFragment = self:addChild(TextFragment { considerHotkey = true })
    self:setInitParams(initParams)
end

function TextLabel:setText(text)
    self.text = text
    self.textFragment:setText(text)
    self:setHotkey(self.textFragment.hotkey)
    self:triggerLayout()
end

function TextLabel:setInput(inputId)
    self.input = inputId
end

function TextLabel.override:onHotkeyEnabled(hotkey)
    Super.onHotkeyEnabled(self, hotkey)
    if self.textFragment.hotkey == hotkey then
        self.textFragment:setShowHotkey(true)
    end
end

function TextLabel.override:onHotkeyDisabled(hotkey)
    Super.onHotkeyDisabled(self, hotkey)
    if self.textFragment.hotkey == hotkey then
        self.textFragment:setShowHotkey(false)
    end
end

function TextLabel:onHotkeyDown()
    local focusHandler = getFocusHandler[self]
    if self.input and focusHandler then
        local input = self:byId(self.input)
        if input then
            input:setFocus(true)
        end
    end
end
function TextLabel.implement:onMouseDown(x, y, button, modState)
    if button == 1 then
        self:onHotkeyDown()
    end
end

function TextLabel.implement:getMeasures()
    local addW =   (self:getStyleParam("LeftPadding") or 0)
                 + (self:getStyleParam("RightPadding") or 0)
                 + 2 * (self:getStyleParam("BorderPadding") or 0)
    local textFullVisible = self:getStyleParam("TextFullVisible")
    
    local tw, th = self.textFragment:getTextMeasures()
    tw = tw + addW
    
    local width       =  self:getStyleParam("Width")
    local height      = (self:getStyleParam("Height") or th)
    local fontInfo    = self.textFragment:getFontInfo()
    local minColumns  = self:getStyleParam("MinColumns")
    local columns     = self:getStyleParam("Columns")
    local maxColumns  = self:getStyleParam("MaxColumns")
    if maxColumns and columns then
        if maxColumns > 0 and columns > maxColumns  then
            columns = maxColumns
        end
    end
    if minColumns and columns and minColumns > columns then
        minColumns = columns
    end

    local xW        = fontInfo:getTextWidth("x")
    local minWidth  = self:getStyleParam("MinWidth")
    
    local bestW
    if columns then
        bestW = columns * xW + addW
    elseif width then
        bestW = width
    else
        bestW = tw
    end
    if textFullVisible and bestW < tw then
        bestW = tw
    end

    local minW
    if minColumns then
        minW = minColumns  * xW + addW
    elseif minWidth then
        minW = minWidth
    else
        minW = tw
    end
    if textFullVisible and minW < tw then
        minW = tw
    end
    if minW > bestW then
        bestW = minW
    end

    local maxW
    if maxColumns then
        maxW  = maxColumns > 0 and (maxColumns * xW + addW) or -1
    else
        maxW = bestW
    end
    if maxW >= 0 and maxW < bestW then
        maxW = bestW
    end

    if textFullVisible and th > height then
        height = th
    end
    return minW, height, bestW, height, maxW, height
end


function TextLabel.override:onLayout(width, height)
    Super.onLayout(self, width, height)
    local iw, ih = self.textFragment:getSize()
    local tw, th, ascent = self.textFragment:getTextMeasures()
    local align = self:getStyleParam("TextAlign")
    if align == "center" then
        self.textFragment:setTextPos(math.floor((iw - tw)/2 + 0.5),
                                     math.floor((ih - th)/2 + ascent + 0.5));
    else
        self.textFragment:setTextPos(  (self:getStyleParam("LeftPadding") or 0)
                                     + (self:getStyleParam("BorderPadding") or 0),
                                     math.floor((ih - th)/2 + ascent + 0.5));
    end
end

return TextLabel

