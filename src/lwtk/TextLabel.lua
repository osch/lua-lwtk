local lwtk = require"lwtk"

local getFocusHandler = lwtk.get.focusHandler
local Compound        = lwtk.Compound
local TextFragment    = lwtk.TextFragment
local Super           = lwtk.Button
local TextLabel       = lwtk.newClass("lwtk.TextLabel", Super)

TextLabel:implementFrom(Compound)

function TextLabel:new(initParams)
    self.textFragment = self:addChild(TextFragment { considerHotkey = true })
    self.align = "left"
    Super.new(self, initParams)
end

function TextLabel:setText(text)
    self.text = text
    self.textFragment:setText(text)
    self:setHotkey(self.textFragment.hotkey)
end

function TextLabel:setInput(inputId)
    self.input = inputId
end

function TextLabel.setAlign(align)
    self.align = align
    self:triggerRedraw()
end

function TextLabel:onHotkeyEnabled(hotkey)
    Super.onHotkeyEnabled(self, hotkey)
    if self.textFragment.hotkey == hotkey then
        self.textFragment:setShowHotkey(true)
    end
end

function TextLabel:onHotkeyDisabled(hotkey)
    Super.onHotkeyDisabled(self, hotkey)
    if self.textFragment.hotkey == hotkey then
        self.textFragment:setShowHotkey(false)
    end
end

function TextLabel:onHotkeyDown()
    local focusHandler = getFocusHandler[self]
    if self.input and focusHandler then
        local input = focusHandler.child[self.input]
        if input then
            input:setFocus(true)
        end
    end
end
function TextLabel:onMouseDown(x, y, button, modState)
    if button == 1 then
        self:onHotkeyDown()
    end
end

function TextLabel:getMeasures()
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
        minW = bestW
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


function TextLabel:onLayout(width, height)
    Super.onLayout(self, width, height)
    local iw, ih = self.textFragment:getSize()
    local tw, th, ascent = self.textFragment:getTextMeasures()
    if self.align == "center" then
        self.textFragment:setTextPos(math.floor((iw - tw)/2 + 0.5),
                                     math.floor((ih - th)/2 + ascent + 0.5));
    else
        self.textFragment:setTextPos(0,
                                     math.floor((ih - th)/2 + ascent + 0.5));
    end
end

return TextLabel
