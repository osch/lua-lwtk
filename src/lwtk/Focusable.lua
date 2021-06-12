local lwtk = require"lwtk"

local call            = lwtk.call
local getFocusHandler = lwtk.get.focusHandler

local Focusable = lwtk.newClass("lwtk.Focusable")

function Focusable:_handleFocusIn()
    self.hasFocus = true
    call("onFocusIn", self)
end

function Focusable:_handleFocusOut()
    self.hasFocus = false
    call("onFocusOut", self)
end

function Focusable:setFocusDisabled(disableFlag)
    if disableFlag == nil then
        disableFlag = true
    end
    disableFlag = disableFlag and true or false
    if self._focusDisabled ~= disableFlag then
        self._focusDisabled = disableFlag
        if disableFlag then
            call("onFocusDisabled", self)
        else
            call("onFocusEnabled", self)
        end
    end
end

function Focusable:setFocus()
    local handler = getFocusHandler[self]
    if handler then
        handler:setFocus(self)
    else
        self._wantsFocus = true
    end
end

return Focusable
