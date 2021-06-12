local lwtk = require"lwtk"

local utf8     = lwtk.utf8
local fillRect = lwtk.draw.fillRect

local TextFragment = lwtk.TextFragment
local Focusable    = lwtk.Focusable
local Super        = lwtk.Button
local PushButton   = lwtk.newClass("lwtk.PushButton", Super)

PushButton:implementFrom(Focusable)
PushButton.getMeasures = lwtk.TextLabel.getMeasures

function PushButton:new(initParams)
    self.textFragment = self:addChild(TextFragment { considerHotkey = true })
    Super.new(self, initParams)
end

function PushButton:setOnClicked(onClicked)
    self.onClicked = onClicked
end
function PushButton:setText(text)
    if self.text ~= text then
        self.text = text
        self.textFragment:setText(text)
        self:setHotkey(self.textFragment.hotkey)
        self:triggerLayout()
    end
end
function PushButton:onMouseEnter(x, y)
    self.mouseEntered = true
    self:setState("hover", true)
end
function PushButton:onMouseLeave(x, y)
    self.mouseEntered = false
    self:setState("hover", false)
end
function PushButton:onMouseDown(x, y, button, modState)
    if button == 1 then
        self.mousePressed = true
        self:setState("pressed", true)
        self:setFocus()
    end
end
function PushButton:onMouseUp(x, y, button, modState)
    if button == 1 then
        self.mousePressed = false
        self:setState("pressed", false)
        if self.state.hover and self.onClicked then
            self:onClicked()
        end
    end
end
function PushButton:onFocusIn()
    self:setState("focused", true)
end
function PushButton:onFocusOut()
    self:setState("focused", false)
end

function PushButton:onDefaultChanged(isDefault)
    self:setState("default", isDefault)
end

local function simulateButtonClick2(self)
    self:setState("pressed", self.mousePressed)
    self:setState("hover",   self.mouseEntered)
    if self.onClicked then
        self:onClicked()
    end
end

local function simulateButtonClick1(self)
    self:setState("hover",   true)
    self:setState("pressed", true)
    self:setTimer(self:getStyleParam("SimulateButtonClickSeconds") or 0.1, 
                  simulateButtonClick2, self)
end

function PushButton:onHotkeyDown()
    simulateButtonClick1(self)
end

function PushButton:onHotkeyEnabled(hotkey)
    Super.onHotkeyEnabled(self, hotkey)
    if self.textFragment.hotkey == hotkey then
        self.textFragment:setShowHotkey(true)
    end
end

function PushButton:onHotkeyDisabled(hotkey)
    Super.onHotkeyDisabled(self, hotkey)
    if self.textFragment.hotkey == hotkey then
        self.textFragment:setShowHotkey(false)
    end
end


function PushButton:onLayout(width, height)
    Super.onLayout(self, width, height)
    local iw, ih = self.textFragment:getSize()
    local tw, th, ascent = self.textFragment:getTextMeasures()
    self.textFragment:setTextPos(math.floor((iw - tw)/2 + 0.5),
                                 math.floor((ih - th)/2 + ascent + 0.5));
end

return PushButton
