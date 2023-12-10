local lwtk = require"lwtk"

local TextFragment = lwtk.TextFragment
local Super        = lwtk.Focusable(lwtk.Button)
local PushButton   = lwtk.newClass("lwtk.PushButton", Super)

PushButton.implement.getMeasures = lwtk.TextLabel.getMeasures
PushButton.setDefault  = lwtk.Focusable.extra.setDefault

PushButton:declare(
    "textFragment",
    "text",
    "onClicked",
    "mousePressed",
    "mouseEntered",
    "_mouseDownTime"
)

function PushButton.override:new(initParams)
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
            self:setState("hover", false)
            self:setState("pressed", false)
            self.mousePressed = false
        else
            self:setHotkey(self.textFragment.hotkey)
            self:setState("hover", self.mouseEntered)
        end
        self:setState("disabled", flag)
        Super.onDisabled(self, flag)
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
function PushButton.implement:onMouseEnter(x, y)
    self.mouseEntered = true
    if not self.disabled then
        self:setState("hover", true)
    end
end
function PushButton.implement:onMouseLeave(x, y)
    self.mouseEntered = false
    if not self.disabled then
        self:setState("hover", false)
    end
end
function PushButton.implement:onMouseDown(x, y, button, modState)
    if button == 1 and not self.disabled then
        self.mousePressed = true
        self:setState("pressed", true)
        self:setFocus(true)
        self._mouseDownTime = self:getCurrentTime()
    end
end

local function onMouseUp2(self)
    self:setState("pressed", false)
    if self.state.hover and self.onClicked then
        self:onClicked()
    end
end

function PushButton.implement:onMouseUp(x, y, button, modState)
    if button == 1 and not self.disabled and self.mousePressed then
        local simulateSeconds = self:getStyleParam("SimulateButtonClickSeconds") or 0.1
        local mouseDownSeconds = self:getCurrentTime() - self._mouseDownTime
        self.mousePressed = false
        if mouseDownSeconds >= simulateSeconds then
            onMouseUp2(self)
        else
            self:setTimer(simulateSeconds - mouseDownSeconds, 
                          onMouseUp2, self)
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

function PushButton.implement:onHotkeyDown()
    simulateButtonClick1(self)
end

function PushButton:onActionFocusedButtonClick()
    simulateButtonClick1(self)
end


function PushButton.override:onHotkeyEnabled(hotkey)
    Super.onHotkeyEnabled(self, hotkey)
    if self.textFragment.hotkey == hotkey then
        self.textFragment:setShowHotkey(true)
    end
end

function PushButton.override:onHotkeyDisabled(hotkey)
    Super.onHotkeyDisabled(self, hotkey)
    if self.textFragment.hotkey == hotkey then
        self.textFragment:setShowHotkey(false)
    end
end


function PushButton.override:onLayout(width, height)
    Super.onLayout(self, width, height)
    local iw, ih = self.textFragment:getSize()
    local tw, th, ascent = self.textFragment:getTextMeasures()
    self.textFragment:setTextPos(math.floor((iw - tw)/2 + 0.5),
                                 math.floor((ih - th)/2 + ascent + 0.5));
end

return PushButton
