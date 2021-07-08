local lwtk = require"lwtk"

local getParent            = lwtk.get.parent
local getStyle             = lwtk.get.style

local Super       = lwtk.Animatable(lwtk.Component)
local Widget      = lwtk.newClass("lwtk.Widget", Super)

function Widget:new(initParams)
    Super.new(self)
    if initParams then
        self:setInitParams(initParams)
    end
end

function Widget:setOnInputChanged(onInputChanged)
    self.onInputChanged = onInputChanged
end

function Widget:notifyInputChanged()
    local w = self
    repeat
        local c = w.onInputChanged
        if c then
            c(w, self)
        end
        w = getParent[w]
    until w == nil
end

function Widget:_setApp(app)
    if self._hasOwnStyle then
        local ownStyle = getStyle[self]
        if not ownStyle.parent then
            ownStyle:_setParentStyle(getStyle[app])
        end
    elseif not getStyle[self] then
        getStyle[self] = getStyle[app]
    end
    Super._setApp(self, app)
end

function Widget:_setParent(parent)
    local pstyle = getStyle[parent]
    if pstyle then
        self:_setStyleFromParent(pstyle)
    end
    Super._setParent(self, parent)
end

return Widget
