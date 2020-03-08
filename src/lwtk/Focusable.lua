local lwtk = require"lwtk"

local call            = lwtk.call
local getFocusHandler = lwtk.get.focusHandler

local Focusable = lwtk.newClass("lwtk.Focusable")

function Focusable:_handleFocusIn()
    call("onFocusIn", self)
end

function Focusable:_handleFocusOut()
    call("onFocusOut", self)
end

function Focusable:setFocus()
    local handler = getFocusHandler[self]
    if handler then
        handler:setFocus(self)
    else
        lwtk.get.wantsFocus[self] = true
    end
end

function Focusable:onKeyDown(key)
    if key == "RIGHT" then
        self:getFocusHandler():moveFocusRight()
        return true
    elseif key == "LEFT" then
        self:getFocusHandler():moveFocusLeft()
        return true
    elseif key == "UP" then
        self:getFocusHandler():moveFocusUp()
        return true
    elseif key == "DOWN" then
        self:getFocusHandler():moveFocusDown()
        return true
    end
end

return Focusable
