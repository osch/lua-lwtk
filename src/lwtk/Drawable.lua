local lwtk = require"lwtk"

local call      = lwtk.call
local getParent = lwtk.get.parent

local Drawable = lwtk.newMixin("lwtk.Drawable")

Drawable:declare(
    "visible",
    "x",  "y",  "w",  "h",
    "id",
    "addChild",
    "_setStyleFromParent"
)

function Drawable:getStyleParam(paramName)
    return getParent[self]:getStyleParam(paramName)
end

function Drawable:getMandatoryStyleParam(paramName)
    local p = self:getStyleParam(paramName)
    if not p then
        lwtk.errorf("Missing StyleParam %q", paramName)
    end
    return p
end

function Drawable.implement:_processMouseEnter(x, y)
    call("onMouseEnter", self, x, y)
end

function Drawable.implement:_processMouseLeave(x, y)
    call("onMouseLeave", self, x, y)
end

function Drawable.implement:_processMouseMove(mouseEntered, x, y)
    call("onMouseMove", self, x, y)
end


function Drawable.implement:_processMouseScroll(dx, dy)
    local comp = self
    while true do
        local onMouseScroll = comp.onMouseScroll
        if onMouseScroll and onMouseScroll(comp, dx, dy) then
            return true
        end
        comp = getParent[comp]
        if not comp then 
            return false
        end
    end
end

function Drawable.implement:_processMouseDown(mx, my, button, modState)
    local onMouseDown = self.onMouseDown
    if onMouseDown then
        onMouseDown(self, mx, my, button, modState)
        return true, true
    end
end

function Drawable.implement:_processMouseUp(mouseEntered, mx, my, button, modState)
    call("onMouseUp", self, mx, my, button, modState)
end

return Drawable
