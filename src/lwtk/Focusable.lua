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
        self._wantsFocus = true
    end
end

return Focusable
