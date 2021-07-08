local lwtk = require"lwtk"

local TextFragment = lwtk.TextFragment
local Super        = lwtk.Focusable(lwtk.Button)
local PushButton   = lwtk.newClass("lwtk.PushButton", Super)

PushButton.getMeasures = lwtk.TextLabel.getMeasures
PushButton.setDefault  = lwtk.Focusable.extra.setDefault

function PushButton:new(initParams)
    Super.new(self)
    self.textFragment = self:addChild(TextFragment { considerHotkey = true })
    self:setInitParams(initParams)
end

function PushButton:setOnClicked(onClicked)
    self.onClicked = onClicked
end

function PushButton:setDisabled(flag)
    flag = flag and true or false
    if flag ~= self.disabled then
        self.disabled = flag
        if flag then
            self:setHotkey(nil)
            self.textFragment:setShowHotkey(false)
            self:setState("hover", false)
            self:setState("pressed", false)
            self.mousePressed = false
        else
            self:setHotkey(self.textFragment.hotkey)
            self.textFragment:setShowHotkey(true)
            self:setState("hover", self.mouseEntered)
        end
        self:setState("disabled", flag)
        self:setFocusDisabled(flag)
    end
end
function PushButton:setText(text)
    if self.text ~= text then
        self.text = text
        self.textFragment:setText(text)
        if not self.disabled then
            self:setHotkey(self.textFragment.hotkey)
        end
        self:triggerLayout()
    end
end
function PushButton:onMouseEnter(x, y)
    self.mouseEntered = true
    if not self.disabled then
        self:setState("hover", true)
    end
end
function PushButton:onMouseLeave(x, y)
    self.mouseEntered = false
    if not self.disabled then
        self:setState("hover", false)
    end
end
function PushButton:onMouseDown(x, y, button, modState)
    if button == 1 and not self.disabled then
        self.mousePressed = true
        self:setState("pressed", true)
        self:setFocus()
    end
end
function PushButton:onMouseUp(x, y, button, modState)
    if button == 1 and not self.disabled and self.mousePressed then
        self.mousePressed = false
        self:setState("pressed", false)
        if self.state.hover and self.onClicked then
            self:onClicked()
        end
    end
end

function PushButton:onDefaultChanged(isCurrentDefault, isPrincipalDefault)
    self.default = isPrincipalDefault
    self:setState("default", isCurrentDefault)
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

function PushButton:onActionFocusedButtonClick()
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
